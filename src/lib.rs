#![no_std]
#![no_main]

mod uart;

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[link_section = ".text"]
#[no_mangle]
pub extern "C" fn _rust_entry() -> ! {
    let mut writer = uart::Writer::new();
    writer.write_string("Hello, world!\n");

	let num:i8 = 10;
	println!("Hexadecimal number is: {:#02X}", num);
    loop {}
}