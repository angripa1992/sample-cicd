#pragma once
#include <string>
#include <vector>

bool PrintRawDataToUSBPrinter(const std::vector<uint8_t>& data, const std::wstring& printerName);