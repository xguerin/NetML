module Ethernet = NetML_Layer_II_Ethernet

module Protocol : sig

  type t =
    | Null
    | Ethernet
    | AX25
    | IEEE802_5
    | ARCNet_BSD
    | SLIP
    | PPP
    | FDDI
    | PPP_HDLC
    | PPP_Ether
    | ATM_RFC1483
    | Raw
    | C_HDLC
    | IEEE802_11
    | FRelay
    | Loop
    | Linux_SLL
    | LTalk
    | PFLog
    | IEEE802_11_Prism
    | IP_over_FC
    | SunATM
    | IEEE802_11_RadioTAP
    | ARCNET_Linux
    | Apple_IP_Over_IEEE1394
    | MTP2_With_PHDR
    | MTP2
    | MTP3
    | SCCP
    | DOCSIS
    | Linux_IRDA
    | User0_LinkType_User15
    | IEEE802_11_AVS
    | BACNET_MS_TP
    | PPP_PPPD
    | GPRS_LLC
    | GPF_T
    | GPF_F
    | Linux_LAPD
    | Bluetooth_HCI_H4
    | USB_Linux
    | PPI
    | IEEE802_15_4
    | SITA
    | ERF
    | Bluetooth_HCI_H4_With_PHDR
    | AX25_KISS
    | LAPD
    | PPP_With_DIR
    | C_HDLC_With_DIR
    | FRelay_With_DIR
    | IPMB_Linux
    | IEEE802_15_4_NONASK_PHY
    | USB_Linux_MMapped
    | FC_2
    | FC_2_WITH_FRAME_DELIMS
    | IPNET
    | CAN_SOCKETCAN
    | IPv4
    | IPv6
    | IEEE802_15_4_NOFCS
    | DBUS
    | DVB_CI
    | MUX27010
    | STANAG_5066_D_PDU
    | NFLOG
    | NetAnalyzer
    | NetAnalyzer_Transparent
    | IPoIB
    | MPEG_2_TS
    | NG40
    | NFC_LLCP
    | Infiniband
    | SCTP
    | USBPCAP
    | RTAC_Serial
    | Bluetooth_LE_LL
    | NetLink
    | Bluetooth_Linux_Monitor
    | Bluetooth_BREDR_BB
    | Bluetooth_LE_LL_WITH_PHDR
    | ProfiBus_DL
    | PKTAP
    | EPON
    | IPMI_HPM_2
    | ZWAVE_R1_R2
    | ZWAVE_R3
    | WattStopper_DLM
    | ISO_14443
    | Unsupported
    [@@deriving yojson]

end

type t = (Protocol.t * Bitstring.t)

type header =
  | Ethernet of Ethernet.t
  | Unsupported
  [@@deriving yojson]

val decode : t -> header option

val expand : t -> NetML_Layer_III.t option
