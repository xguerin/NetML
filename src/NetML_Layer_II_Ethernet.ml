open NetML_Layer_III

module MAC = struct
  type t = int * int * int * int * int * int [@@deriving yojson]
end

module VLAN = struct
  type t = {
    pcp : int;
    dei : bool;
    vid : int;
  } [@@deriving yojson]
end

type t = {
  destination : MAC.t;
  source      : MAC.t;
  vlans       : VLAN.t list;
  protocol    : NetML_Layer_III.Protocol.t option;
} [@@deriving yojson]

let rec decode_protocol vlans payload =
  let open NetML_Layer_III in
  match%bitstring payload with
  | {|  ( 0x8100 | 0x0081 ) : 16;
        pcp                 : 3;
        dei                 : 1;
        vid                 : 12 : bigendian;
        next                : -1 : bitstring
    |} ->
    let open VLAN in
    let vlan = { pcp = pcp; dei = dei; vid = vid } in
    decode_protocol (vlans @ [ vlan ]) next
  | {|  ( 0x0800 | 0x0008 ) : 16;
        next                : -1 : bitstring
    |} -> (vlans, Some Protocol.IPv4, next)
  | {| _ |} -> ([], None, payload)

let decode_header data =
  match%bitstring data with
  | {|  d0 : 8; d1 : 8; d2 : 8; d3 : 8; d4 : 8; d5 : 8;
        s0 : 8; s1 : 8; s2 : 8; s3 : 8; s4 : 8; s5 : 8;
        payload : -1 : bitstring
    |} ->
    let destination = (d0, d1, d2, d3, d4, d5) in
    let source = (s0, s1, s2, s3, s4, s5) in
    let (vlans, protocol, rem) = decode_protocol [] payload in
    Some ({ destination; source; vlans; protocol }, rem)
  | {| _ |} -> None

let decode data =
  let open Core_kernel.Option.Monad_infix in
  decode_header data >>= fun (hdr, _) -> Some (hdr)

let expand data =
  let open Core_kernel.Option.Monad_infix in
  decode_header data  >>= fun (hdr, rem) ->
  hdr.protocol        >>= fun proto ->
  Some (proto, rem)
