/* BSD Zero Clause License */

/* Copyright (C) 2022-2025 Mintsuki and contributors.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

module limine;

/* Misc */

macro ulong[4] limine_requests_start_marker() => { 0xf6b8f4b39de7d1ae, 0xfab91a6940fcb9cf,
                                                     0x785c6ed015d3e316, 0x181e920a7852b9d9 };
macro ulong[4] limine_requests_end_marker() => { 0xadc0e0531bb10d03, 0x9572709f31764c62, 0, 0 };

macro ulong[4] limine_base_revision($n) => { 0xf9562b2d5c95a6c8, 0x6a7b384944536bdc, $n, 0 };

macro bool limine_base_revision_supported($var) => $var[2] == 0;

macro bool limine_loaded_base_revision_valid($var) => $var[1] != 0x6a7b384944536bdc;
macro ulong limine_loaded_base_revision($var) => $var[1];

struct Uuid {
    uint a;
    ushort b;
    ushort c;
    char[8] d;
}

const uint LIMINE_MEDIA_TYPE_GENERIC = 0;
const uint LIMINE_MEDIA_TYPE_OPTICAL = 1;
const uint LIMINE_MEDIA_TYPE_TFTP = 2;

struct File {
    ulong revision;
    void* address;
    ulong size;
    char* path;
    char* string;
    uint media_type;
    uint unused;
    uint tftp_ip;
    uint tftp_port;
    uint partition_index;
    uint mbr_disk_id;
    Uuid gpt_disk_uuid;
    Uuid gpt_part_uuid;
    Uuid part_uuid;
}

/* Boot info */

macro ulong[4] limine_bootloader_info_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b, 
                                                         0xf55038d8e2a1202f, 0x279426fcf5f59740 };

struct BootloaderInfoResponse {
    ulong revision;
    char* name;
    char* version;
}

struct BootloaderInfoRequest {
    ulong[4] id;
    ulong revision;
    BootloaderInfoResponse* response;
}

/* Executable command line */

macro ulong[4] limine_executable_cmdline_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                            0x4b161536e598651e, 0xb390ad4a2f1f303a };

struct ExecutableCmdlineResponse {
    ulong revision;
    char* cmdline;
}

struct ExecutableCmdlineRequest {
    ulong[4] id;
    ulong revision;
    ExecutableCmdlineResponse* response;
}

/* Firmware type */

macro ulong[4] limine_firmware_type_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                       0x8c2f75d90bef28a8, 0x7045a4688eac00c3 };

const ulong LIMINE_FIRMWARE_TYPE_X86BIOS = 0;
const ulong LIMINE_FIRMWARE_TYPE_EFI32 = 1;
const ulong LIMINE_FIRMWARE_TYPE_EFI64 = 2;
const ulong LIMINE_FIRMWARE_TYPE_SBI = 3;

struct FirmwareTypeResponse {
    ulong revision;
    ulong firmware_type;
}

struct FirmwareTypeRequest {
    ulong[4] id;
    ulong revision;
    FirmwareTypeResponse* response;
}

/* Stack size */

macro ulong[4] limine_stack_size_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                    0x224ef0460a8e8926, 0xe1cb0fc25f46ea3d };

struct StackSizeResponse {
    ulong revision;
}

struct StackSizeRequest {
    ulong[4] id;
    ulong revision;
    StackSizeResponse* response;
    ulong stack_size;
}

/* HHDM */

macro ulong[4] limine_hhdm_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                              0x48dcf1cb8ad2b852, 0x63984e959a98244b };

struct HhdmResponse {
    ulong revision;
    ulong offset;
}

struct HhdmRequest {
    ulong[4] id;
    ulong revision;
    HhdmResponse* response;
}

/* Framebuffer */

macro ulong[4] limine_framebuffer_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                     0x9d5827dcd881dd75, 0xa3148604f6fab11b };

const uint LIMINE_FRAMEBUFFER_RGB = 1;

struct VideoMode {
    ulong pitch;
    ulong width;
    ulong height;
    ushort bpp;
    char memory_model;
    char red_mask_size;
    char red_mask_shift;
    char green_mask_size;
    char green_mask_shift;
    char blue_mask_size;
    char blue_mask_shift;
}

struct Framebuffer {
    void* address;
    ulong width;
    ulong height;
    ulong pitch;
    ushort bpp;
    char memory_model;
    char red_mask_size;
    char red_mask_shift;
    char green_mask_size;
    char green_mask_shift;
    char blue_mask_size;
    char blue_mask_shift;
    char[7] unused;
    ulong edid_size;
    void* edid;
    /* Response revision 1 */
    ulong mode_count;
    VideoMode** modes;
}

struct FramebufferResponse {
    ulong revision;
    ulong framebuffer_count;
    Framebuffer** framebuffers;
}

struct FramebufferRequest {
    ulong[4] id;
    ulong revision;
    FramebufferResponse* response;
}

/* Paging mode */

macro ulong[4] limine_paging_mode_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                     0x95c1a0edab0944cb, 0xa4e5cb3842f7488a };

const ulong LIMINE_PAGING_MODE_X86_64_4LVL = 0;
const ulong LIMINE_PAGING_MODE_X86_64_5LVL = 1;
const ulong LIMINE_PAGING_MODE_X86_64_MIN = LIMINE_PAGING_MODE_X86_64_4LVL;
const ulong LIMINE_PAGING_MODE_X86_64_DEFAULT = LIMINE_PAGING_MODE_X86_64_4LVL;

const ulong LIMINE_PAGING_MODE_AARCH64_4LVL = 0;
const ulong LIMINE_PAGING_MODE_AARCH64_5LVL = 1;
const ulong LIMINE_PAGING_MODE_AARCH64_MIN = LIMINE_PAGING_MODE_AARCH64_4LVL;
const ulong LIMINE_PAGING_MODE_AARCH64_DEFAULT = LIMINE_PAGING_MODE_AARCH64_4LVL;

const ulong LIMINE_PAGING_MODE_RISCV_SV39 = 0;
const ulong LIMINE_PAGING_MODE_RISCV_SV48 = 1;
const ulong LIMINE_PAGING_MODE_RISCV_SV57 = 2;
const ulong LIMINE_PAGING_MODE_RISCV_MIN = LIMINE_PAGING_MODE_RISCV_SV39;
const ulong LIMINE_PAGING_MODE_RISCV_DEFAULT = LIMINE_PAGING_MODE_RISCV_SV48;

const ulong LIMINE_PAGING_MODE_LOONGARCH_4LVL = 0;
const ulong LIMINE_PAGING_MODE_LOONGARCH_MIN = LIMINE_PAGING_MODE_LOONGARCH_4LVL;
const ulong LIMINE_PAGING_MODE_LOONGARCH_DEFAULT = LIMINE_PAGING_MODE_LOONGARCH_4LVL;

struct PagingModeResponse {
    ulong revision;
    ulong mode;
}

struct PagingModeRequest {
    ulong[4] id;
    ulong revision;
    PagingModeResponse* response;
    ulong mode;
    ulong max_mode;
    ulong min_mode;
}

/* MP */

macro ulong[4] limine_mp_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                            0x95a67b819a1b857e, 0xa0b61b723b6a73e0 };

alias GotoAddress = fn void(MpInfo*);

// x86_64/i386 specific
const uint LIMINE_MP_RESPONSE_X86_64_X2APIC = 1 << 0;

struct MpInfo {
    uint processor_id;
    uint lapic_id;
    ulong reserved;
    GotoAddress goto_address;
    ulong extra_argument;
}

struct MpResponse {
    ulong revision;
    uint flags;
    uint bsp_lapic_id;
    ulong cpu_count;
    MpInfo** cpus;
}

const ulong LIMINE_MP_REQUEST_X86_64_X2APIC = 1 << 0;

struct MpRequest {
    ulong[4] id;
    ulong revision;
    MpResponse* response;
    ulong flags;
}

/* Memory map */

macro ulong[4] limine_memmap_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                0x67cf3d9d378a806f, 0xe304acdfc50c3c62 };

enum MemmapType : ulong
{
	USABLE,
	RESERVED,
	ACPI_RECLAIMABLE,
	ACPI_NVS,
	BAD_MEMORY,
	BOOTLOADER_RECLAIMABLE,
	EXECUTABLE_AND_MODULES,
	FRAMEBUFFER,
	ACPI_TABLES,
}

struct MemmapEntry {
    ulong base;
    ulong length;
    MemmapType type;
}

struct MemmapResponse {
    ulong revision;
    ulong entry_count;
    MemmapEntry** entries;
}

struct MemmapRequest {
    ulong[4] id;
    ulong revision;
    MemmapResponse* response;
}

/* Entry point */

macro ulong[4] limine_entry_point_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                     0x13d86c035a1cd3e1, 0x2b0caa89d8f3026a };

alias EntryPoint = fn void();

struct EntryPointResponse {
    ulong revision;
}

struct EntryPointRequest {
    ulong[4] id;
    ulong revision;
    EntryPointResponse* response;
    EntryPoint entry;
}

/* Executable File */

macro ulong[4] limine_executable_file_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                         0xad97e90e83f1ed67, 0x31eb5d1c5ff23b69 };

struct ExecutableFileResponse {
    ulong revision;
    File* executable_file;
}

struct ExecutableFileRequest {
    ulong[4] id;
    ulong revision;
    ExecutableFileResponse* response;
}

/* Module */

macro ulong[4] limine_module_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                0x3e7e279702be32af, 0xca1c4f3bd1280cee };

const ulong LIMINE_INTERNAL_MODULE_REQUIRED = 1 << 0;
const ulong LIMINE_INTERNAL_MODULE_COMPRESSED = 1 << 1;

struct InternalModule {
    char* path;
    char* string;
    ulong flags;
}

struct ModuleResponse {
    ulong revision;
    ulong module_count;
    File** modules;
}

struct ModuleRequest {
    ulong[4] id;
    ulong revision;
    ModuleResponse* response;
    /* Request revision 1 */
    ulong internal_module_count;
    InternalModule** internal_modules;
}

/* RSDP */

macro ulong[4] limine_rsdp_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                              0xc5e77b6b397e7b43, 0x27637845accdcf3c };

struct RsdpResponse {
    ulong revision;
    void* address;
}

struct RsdpRequest {
    ulong[4] id;
    ulong revision;
    RsdpResponse* response;
}

/* SMBIOS */

macro ulong[4] limine_smbios_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                0x9e9046f11e095391, 0xaa4a520fefbde5ee };

struct SmbiosResponse {
    ulong revision;
    ulong entry_32;
    ulong entry_64;
}

struct SmbiosRequest {
    ulong[4] id;
    ulong revision;
    SmbiosResponse* response;
}

/* EFI system table */

macro ulong[4] limine_efi_system_table_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                          0x5ceba5163eaaf6d6, 0x0a6981610cf65fcc };

struct EfiSystemTableResponse {
    ulong revision;
    ulong address;
}

struct EfiSystemTableRequest {
    ulong[4] id;
    ulong revision;
    EfiSystemTableResponse* response;
}

/* EFI memory map */

macro ulong[4] limine_efi_memmap_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                    0x7df62a431d6872d5, 0xa4fcdfb3e57306c8 };

struct EfiMemmapResponse {
    ulong revision;
    void* memmap;
    ulong memmap_size;
    ulong desc_size;
    ulong desc_version;
}

struct EfiMemmapRequest {
    ulong[4] id;
    ulong revision;
    EfiMemmapResponse* response;
}

/* Date at boot */

macro ulong[4] limine_date_at_boot_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                      0x502746e184c088aa, 0xfbc5ec83e6327893 };

struct DateAtBootResponse {
    ulong revision;
    long timestamp;
}

struct DateAtBootRequest {
    ulong[4] id;
    ulong revision;
    DateAtBootResponse* response;
}

/* Executable address */

macro ulong[4] limine_executable_address_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                            0x71ba76863cc55f63, 0xb2644a48c516a487 };

struct ExecutableAddressResponse {
    ulong revision;
    ulong physical_base;
    ulong virtual_base;
}

struct ExecutableAddressRequest {
    ulong[4] id;
    ulong revision;
    ExecutableAddressResponse* response;
}

/* Device Tree Blob */

macro ulong[4] limine_dtb_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                             0xb40ddb48fb54bac7, 0x545081493f81ffb7 };

struct DtbResponse {
    ulong revision;
    void* dtb_ptr;
}

struct DtbRequest {
    ulong[4] id;
    ulong revision;
    DtbResponse* response;
}

/* RISC-V Boot Hart ID */

macro ulong[4] limine_riscv_bsp_hartid_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                          0x1369359f025525f9, 0x2ff2a56178391bb6 };

struct RiscvBspHartidResponse {
    ulong revision;
    ulong bsp_hartid;
}

struct RiscvBspHartidRequest {
    ulong[4] id;
    ulong revision;
    RiscvBspHartidResponse* response;
}

/* Bootloader Performance */

macro ulong[4] limine_bootloader_performance_request_id() => { 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b,
                                                                0x6b50ad9bf36d13ad, 0xdc4c7e88fc759e17 };

struct BootloaderPerformanceResponse {
    ulong revision;
    ulong reset_usec;
    ulong init_usec;
    ulong exec_usec;
}

struct BootloaderPerformanceRequest {
    ulong[4] id;
    ulong revision;
    BootloaderPerformanceResponse* response;
}

/*
 * Usage example:
 * 
 * @section(".limine_reqs")
 * BootloaderInfoRequest bootloader_info_request = {
 *     .id = limine_bootloader_info_request_id(),
 *     .revision = 5
 * };
 *
 * You'll need to place request markers in your linker script and use @section
 * attributes to ensure proper placement of request structures.
 */
