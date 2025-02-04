pub fn info() -> String {
    return String::from(
        "
#########################################################
Info of the Gordo Gopher Hole
#########################################################
LinkedIn: https://www.linkedin.com/in/mike-russell-is-a-human/
GitHub: irishgordo

Disclaimer: Views expressed are my own and do not reflect the views of my employer.
    ",
    );
}
pub fn free_gear() -> String {
    return String::from(
        "
#####################################################################
Free Gear, for c2society/DC702 Just Submit A PR With What You Want
Add your Discord Username or Github Handle to claim
####################################################################
raspberrypi-realm:
  - item: combo-raspberrypi-rack-mount-1U-thing
    descrption: 'RaspberryPi 4 Model Bs, 2 of them, connected to a 1U rack mount w/ both RaspberryPi 4 Model Bs having a HDMI breakout (consume micro hdmi)'
    quantity: 1
    additional-notes: 'no microsd cards, no power cable'
    claim:
      - user: ''
  - item: raspberrypi-4-model-b-hdmi-breakout-board
    description: 'RaspberryPi 4 Model B, just a breakout board, to attach to the RaspberryPi 4 Model B, that provide then 2 HDMI ports out from the micro hdmi'
    quantity: 1
    additional-notes: 'no microsd cards, no power cable'
    claim:
      - user: ''
  - item: raspberrypi-4
    description: 'RaspberryPi 4 Model B in a somewhat case'
    quantity: 1
    additional-notes: 'no microsd cards'
    claim:
      - user: 'jdewald'
  - item: raspberrypi-circa-2011
    description: 'I do not recall the model, but its an older RaspberryPi, composite video out, circa 2011'
    quantity: 1
    additional-notes: 'no SD card, no power cable'
    claim:
      - user: ''
---
networking-related-realm:
  - item: mikrotik-crs306-1g-4s
    description: 'a mikrotik PoE/or-self-powered, ethernet in & 4 sfp+ out switch'
    quantity: 1
    additional-notes: 'not sure if I will be able to find a barrel plug for this 12v little switch but I will try'
    claim:
      - user: ''
  - item: netgate-sg-1000
    description: 'it is a little device that can run PFSense, I can not recall much more, has console/usb-otg 1 lan out 1 wan in, meant to be a firewall iirc'
    quantity: 1
    additional-notes: 'not sure I will be able to find the barrel plug for this either, it is 5V DC, 2.5A'
    claim:
      - user: ''
  - item: netgear-prosafe-5-port-switch
    description: 'its a switch from netgear gs105v5'
    quantity: 1
    additional-notes: 'idk about barrel plug'
    claim:
      - user: ''
  - item: netgear-prosafe-8-port-switch
    description: 'its a switch from netgear gs108v4'
    quantity: 1
    additional-notes: 'idk about barrel plug'
    claim:
      - user: ''
  - item: think-penguin-wireless-n-adapter
    description: 'its a usb think penguin wireless n usb adapter with external antenna'
    quantity: 1
    additional-notes: 'model tpe-n150usbl no microusb cable'
    claim:
      - user: ''
  - item: atheros-ar9271-wifi-adapter
    description: 'atheros ar9271 wireless usb adapter with an antenna'
    quantity: 1
    additional-notes: ''
    claim:
      - user: ''
  - item: sfp-plus-pcie-10gtek-single-port-card
    description: 'an sfp+ 10G pcie card w a single port'
    quantity: 1
    additional-notes: ''
    claim:
      - user: ''
  - item: wrt54g-v5-linksys-wireless-g-switch-router
    description: 'an old wirelessg 2.45ghz linksys wireless g switch router'
    quantity: 1
    additional-notes: 'probably had tomato flashed on it at one point idk whats going on with it currently'
    claim:
      - user: ''
  - item: wrt54g2-v1-linksys-switch-router
    description: 'an olde wirless g broadband router'
    additional-notes: 'no idea if it can be flashed to something like ddwrt or tomato but probably idk what state its in'
    quantity: 1
    claim:
      - user: ''
---
storage-related:
  - item: wd-1tb-spinning-disk-sata
    description: 'a 1tb sata spinning disk drive wd10ezex'
    quantity: 1
    additional-notes: 'probably low hours smartctl or something might give more info idk, iirc'
    claim:
      - user: ''
  - item: seagate-nas-hdd-2000gb
    descritption: 'a 2tb seagate nas hdd, spinning disk, sata w1h25k31'
    additional-notes: 'probably low hours smartctl or something might give more info idk, iirc'
    quantity: 1
    claim:
      - user: ''
  - item: hgst-3tb-spinning-disk
    description: 'a 3tb sata spinning hdd, hus723030als640'
    additional-notes: 'probably low hours smartctl or something might give more info idk, iirc'
    quantity: 1
    claim:
      - user: ''
  - item: seagate-nas-hdd-4tb
    description: 'a 4tb sata spinning disk nas hdd'
    additional-notes: 'probably low hours smartctl or something might give more info idk, iirc'
    quantity: 1
    claim:
      - user: ''
---
servers:
  - item: supermicro-502-2
    description: '1U its like an intel atom x86/64 server little tiny thing like 4 cores maybe 4/8GiB DDR3 Mem'
    additional-notes: 'ummm idk whats on there, iirc fans are loud :P, 2 nic ports, I think supermicro ipmi tool like ipmiview works with it... not sure on memory or storage'
    quantity: 1
    claim:
      - user: ''
  - item: supermicro-other
    description: 'like 16c 32 thread supermicro server 1U, 64G mem'
    additional-notes: 'ipmi view works and I think theres a raid card somewhere'
    quantity: 1
    claim:
      - user: ''
---
phone-things:
  - item: rabbit-r1
    description: 'a rabbit r1 thing'
    quantity: 1
    additional-notes: ''
    claim:
      - user: ''
  - item: librem5-phone
    description: 'a librem5 phone from purism'
    quantity: 1
    additional-notes: ''
    claim:
      - user: ''
---
memory:
  - item: gskill-ripjaw-ddr4-sodimm-2666
    description: 'laptop memory, ddr4 sodimm, 2 32GB modules'
    additional-notes: '64G in total'
    quantity: 1
    claim:
      - user: ''
---
computers:
  - item: devterm-clockwork-pi
    description: 'DevTerm ClockWork Pi, its like a cyberdeck build keyboard and trackball on it'
    additional-notes: 'A04G 2GB - no microssd, no 18650 batteries, can just be powered over USB but the 18650 make it portable, clockwork devterm you can flash the microsd for the OS and whatever'
    quantity: 1
    claim:
      - user: 'justinbarry'
",
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn free_gear_not_empty() {
        let result = free_gear();
        assert_ne!(result, "");
    }

    #[test]
    fn info_not_empty() {
        let result = info();
        assert_ne!(result, "");
    }
}
