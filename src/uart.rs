use uart_16550::MmioSerialPort;
use core::fmt;

// Memory mapped UART address for virtio console in qemu
const SERIAL_PORT_BASE_ADDRESS: usize = 0x1000_0000;

pub struct Writer {
    serial_port: MmioSerialPort,
}

impl Writer {

    pub fn new() -> Self {
        Self { serial_port: unsafe { MmioSerialPort::new(SERIAL_PORT_BASE_ADDRESS) } }
    }

    pub fn write_string(&mut self, s: &str) {
        for byte in s.bytes() {
            self.serial_port.send(byte);
        }
    }
}

impl fmt::Write for Writer {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        self.write_string(s);
        Ok(())
    }
}

#[macro_export]
macro_rules! print {
    ($($arg:tt)*) => ($crate::uart::_print(format_args!($($arg)*)));
}

#[macro_export]
macro_rules! println {
    () => ($crate::print!("\n"));
    ($($arg:tt)*) => ($crate::print!("{}\n", format_args!($($arg)*)));
}

#[doc(hidden)]
pub fn _print(args: fmt::Arguments) {
    use core::fmt::Write;
    let mut writer = Writer::new();
    writer.write_fmt(args).unwrap();
}
