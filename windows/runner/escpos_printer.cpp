#include <Windows.h>
#include <string>
#include <vector>
#include <winspool.h>

bool PrintRawDataToUSBPrinter(
        const std::vector<uint8_t>& data,
        const std::wstring& printer_name
) {
    HANDLE printer_handle;
    DOC_INFO_1 doc_info;
    DWORD bytes_written;

    if (!OpenPrinterW((LPWSTR)printer_name.c_str(), &printer_handle, NULL)) {
        return false;
    }

    doc_info.pDocName = (LPWSTR)L"Flutter Print Job";
    doc_info.pOutputFile = NULL;
    doc_info.pDatatype = (LPWSTR)L"RAW";

    if (StartDocPrinter(printer_handle, 1, (LPBYTE)&doc_info) == 0) {
        ClosePrinter(printer_handle);
        return false;
    }

    if (!StartPagePrinter(printer_handle)) {
        EndDocPrinter(printer_handle);
        ClosePrinter(printer_handle);
        return false;
    }

    if (!WritePrinter(printer_handle, (void*)data.data(), data.size(), &bytes_written)) {
        EndPagePrinter(printer_handle);
        EndDocPrinter(printer_handle);
        ClosePrinter(printer_handle);
        return false;
    }

    EndPagePrinter(printer_handle);
    EndDocPrinter(printer_handle);
    ClosePrinter(printer_handle);
    return true;
}
