#include "print_channel.h"
#include "escpos_printer.h"

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

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
