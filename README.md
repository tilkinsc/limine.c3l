# Limine.c3l

A simple library for exposing the limine requests for limine bootloader

## Usage

1. Clone into your lib search path
2. Add `limine` to your project.json in the dependencies array
3. See manifest.json for supported architectures

Example:
```json
{
    "version": "1.0.0",
    "authors": ["Cody Tilkins"],
    "langrev": "1",
    "warnings": ["all"],
    "sources": [ "src/**" ],
    "dependency-search-paths": [ "lib" ],
    "dependencies": [ "limine" ],
    "target": "elf-x64",
    "no-entry": true,
    "link-libc": false,
    "use-stdlib": false,
    "reloc": "pic",
    "single-module": false,
    "safe": true,
    "strip-unused": false,
    "soft-float": false,
    "x86vec": "none",
    "fp-math": "strict",
    "x86cpu": "baseline",
    "panicfn": "std::core::builtin::panic",
    "targets": {
        "kernel-release": {
            "cpu": "generic",
            "type": "object-files",
            "opt": "O2",
            "debug-info": "none"
        },
        "kernel-debug": {
            "cpu": "generic",
            "type": "object-files",
            "opt": "O0",
            "debug-info": "full"
        }
    }
}
```

4. Add global variables and limine requests

```c3
module limine;

attrdef @LimineStart = @section(".limine_requests_start"), @nostrip, @align(8);
attrdef @LimineEnd = @section(".limine_requests_end"), @nostrip, @align(8);
attrdef @LimineRequest = @section(".limine_requests"), @nostrip, @align(8);

ulong[4] start_marker @LimineStart = limine_requests_start_marker();

ulong[4] base_revision @LimineRequest = limine_base_revision(4);

BootloaderInfoRequest bootloader_info_request @LimineRequest = {
    .id = limine_bootloader_info_request_id(),
    .revision = 4,
    .response = null
};

// ... more requests here ... //

ulong[4] end_marker @LimineEnd = limine_requests_end_marker();
```

```linker
SECTIONS {

	// . is at beginning of kernel

	__kernel_start = .;
	
	.limine_requests : {
		KEEP(*(.limine_requests_start))
		KEEP(*(.limine_requests))
		KEEP(*(.limine_requests_end))
	} :limine_requests

	// ... rest of sections ...

    __kernel_end = .;
}
```
