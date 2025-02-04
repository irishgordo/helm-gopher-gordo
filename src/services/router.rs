use crate::extra;
use gophermap::{GopherMenu, ItemType};
use std::io::{self};

const GORDONETHYPE: &'static str = "##   G  O  R  D  O - - - N  E  T   ##";

fn put_header_up_der(menu: &GopherMenu<&std::net::TcpStream>) -> io::Result<()> {
    menu.info("==========================================================")?;
    menu.info(&GORDONETHYPE)?;
    menu.info("==========================================================")?;
    Ok(())
}

fn _convert_to_individual_menu_info_segments(
    str_to_use: String,
    menu_to_use: &GopherMenu<&std::net::TcpStream>,
) -> io::Result<()> {
    let str_lines = str_to_use.lines();
    for ln in str_lines {
        menu_to_use.info(ln)?;
    }
    Ok(())
}

pub fn route(
    routing_line: &str,
    menu: &GopherMenu<&std::net::TcpStream>,
    host: &str,
    port: u16,
) -> io::Result<()> {
    let menu_link = |text: &str, selector: &str| {
        menu.write_entry(ItemType::Directory, text, selector, host, port)
    };
    match routing_line {
        "/" | "" => {
            put_header_up_der(&menu)?;
            menu.info("Home Menu")?;
            menu_link("Gear Freebies", "/get-free-gear")?;
            menu_link("Info", "/info")?;
        }
        "/get-free-gear" => {
            put_header_up_der(&menu)?;
            menu.info("Free Gear, Just Submit A PR")?;
            menu_link("Home", "/")?;
            _convert_to_individual_menu_info_segments(extra::stuff::free_gear(), &menu)?;
        }
        "/info" => {
            put_header_up_der(&menu)?;
            menu.info("Info")?;
            menu_link("Home", "/")?;
            _convert_to_individual_menu_info_segments(extra::stuff::info(), &menu)?;
        }
        _x => {
            put_header_up_der(&menu)?;
            menu_link("Home", "/")?;
            menu.info("Can not find the page, not implemented yet...")?;
        }
    }
    Ok(())
}
