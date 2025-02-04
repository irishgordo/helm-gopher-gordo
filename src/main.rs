use gophermap::GopherMenu;
use std::io::{self, BufRead, BufReader};
use std::net::{TcpListener, TcpStream};
use std::thread;
pub mod extra;
pub mod services;

const PORT: u16 = 70;
const HOST: &str = "0.0.0.0";
const LBHOST: &str = "gopher.gordoughnet.com";

fn handle_client(stream: TcpStream) -> io::Result<()> {
    let mut line = String::new();
    BufReader::new(stream.try_clone()?).read_line(&mut line)?;
    let mut menu = GopherMenu::with_write(&stream);
    services::router::route(&line.trim(), &menu, &LBHOST, PORT)?;
    menu.end()?;
    Ok(())
}

fn main() -> io::Result<()> {
    println!("...the gordo gopher hole server binary is starting up...");
    let listener = TcpListener::bind(format!("{}:{}", HOST, PORT))?;
    for stream in listener.incoming() {
        println!("...stream happening...");
        thread::spawn(move || handle_client(stream?));
    }
    Ok(())
}
