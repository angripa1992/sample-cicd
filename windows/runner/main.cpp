#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <windows.h>
#include <memory>
#include <string>
#include <vector>

#include "flutter_window.h"
#include "utils.h"
#include "escpos_printer.h" // Your custom print logic

void RegisterPrintMethodChannel(flutter::FlutterViewController* controller) {
    auto messenger = controller->engine()->messenger();

    auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            messenger, "escpos_usb_printer", &flutter::StandardMethodCodec::GetInstance());

    channel->SetMethodCallHandler(
            [](const flutter::MethodCall<flutter::EncodableValue>& call,
               std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
                if (call.method_name() == "print") {
                    const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
                    if (!args) {
                        result->Error("INVALID_ARGUMENTS", "Expected a map of arguments.");
                        return;
                    }

                    auto bytes_it = args->find(flutter::EncodableValue("bytes"));
                    auto printer_it = args->find(flutter::EncodableValue("printer"));

                    if (bytes_it == args->end() || printer_it == args->end()) {
                        result->Error("MISSING_ARGUMENTS", "Missing 'bytes' or 'printer' key.");
                        return;
                    }

                    const auto& byte_list = std::get<flutter::EncodableList>(bytes_it->second);
                    std::vector<uint8_t> data;
                    for (const auto& val : byte_list) {
                        data.push_back(std::get<int>(val));
                    }

                    std::wstring printer_name_w(
                            std::get<std::string>(printer_it->second).begin(),
                            std::get<std::string>(printer_it->second).end());

                    if (PrintRawDataToUSBPrinter(data, printer_name_w)) {
                        result->Success(flutter::EncodableValue(true));
                    } else {
                        result->Error("PRINT_FAILED", "Failed to send data to printer.");
                    }
                } else {
                    result->NotImplemented();
                }
            });
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
        _In_ wchar_t* command_line, _In_ int show_command) {
// Attach to console when present or create a new console when running with a debugger.
if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
CreateAndAttachConsole();
}

::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);  // Required for COM

flutter::DartProject project(L"data");
std::vector<std::string> command_line_arguments = GetCommandLineArguments();
project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

FlutterWindow window(project);
Win32Window::Point origin(0, 0);
Win32Window::Size size(1080, 800);
if (!window.CreateAndShow(L"Klikit Business", origin, size)) {
return EXIT_FAILURE;
}

// Register the custom method channel to communicate with Flutter
RegisterPrintMethodChannel(window.controller());

window.SetQuitOnClose(false);

::MSG msg;
while (::GetMessage(&msg, nullptr, 0, 0)) {
::TranslateMessage(&msg);
::DispatchMessage(&msg);
}

::CoUninitialize();
return EXIT_SUCCESS;
}
