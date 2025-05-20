#ifndef USB_PRINTER_H
#define USB_PRINTER_H

#include <vector>
#include <string>

bool PrintRawDataToUSBPrinter(
        const std::vector<uint8_t>& data,
        const std::wstring& printer_name
);

#endif
