#![no_std]
#![no_main]

use core::panic::PanicInfo;

extern "C" {
    fn print_stuff();
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[link_section = ".text"]
#[no_mangle]
pub extern "C" fn _rust_entry() -> ! {
    unsafe {
        print_stuff();
    }
    loop {}
}