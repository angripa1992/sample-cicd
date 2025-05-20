#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include "escpos_printer.h"
#include "flutter_window.h"
#include "utils.h"
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

void RegisterPrintMethodChannel(flutter::FlutterViewController* controller) {
    auto messenger = controller->engine()->messenger();

    auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            messenger, "escpos_usb_printer",
                    &flutter::StandardMethodCodec::GetInstance());

    channel->SetMethodCallHandler(
            [](const flutter::MethodCall<flutter::EncodableValue>& call,
               std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
                if (call.method_name() == "print") {
                    const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
                    if (!args) {
                        result->Error("INVALID_ARGUMENTS", "Expected arguments");
                        return;
                    }

                    auto data_iter = args->find(flutter::EncodableValue("bytes"));
                    auto name_iter = args->find(flutter::EncodableValue("printer"));

                    if (data_iter == args->end() || name_iter == args->end()) {
                        result->Error("MISSING_ARGS", "Missing bytes or printer name");
                        return;
                    }

                    const auto& byteList = std::get<flutter::EncodableList>(data_iter->second);
                    std::vector<uint8_t> bytes;
                    for (const auto& val : byteList) {
                        bytes.push_back(std::get<int>(val));
                    }

                    std::wstring printerName = std::wstring(
                            std::get<std::string>(name_iter->second).begin(),
                            std::get<std::string>(name_iter->second).end());

                    if (PrintRawDataToUSBPrinter(bytes, printerName)) {
                        result->Success(flutter::EncodableValue(true));
                    } else {
                        result->Error("PRINT_FAILED", "Failed to print.");
                    }
                } else {
                    result->NotImplemented();
                }
            });
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);

  Win32Window::Point origin(0, 0);
  Win32Window::Size size(1080, 800);
  if (!window.CreateAndShow(L"Klikit Business", origin, size)) {
    return EXIT_FAILURE;
  }

  window.SetQuitOnClose(false);
  RegisterPrintMethodChannel(&window);
  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}

