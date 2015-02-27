open Bitstring
open Core.Std

type t = {
  source      : int;
  destination : int;
  seqnum      : int;
  acknum      : int;
  length      : int;
  checksum    : int;
} with fields

let decode data =
  bitmatch data with
  | { source      : 16 : bigendian;
      destination : 16 : bigendian;
      seq         : 32 : bigendian;
      ack         : 32 : bigendian;
      offset      : 4;
      _           : 3;
      _           : 1; (* ns *)
      _           : 1; (* cwr *)
      _           : 1; (* ece *)
      _           : 1; (* urg *)
      _           : 1; (* ack *)
      _           : 1; (* psh *)
      _           : 1; (* rst *)
      _           : 1; (* syn *)
      _           : 1; (* fin *)
      _           : 16 : bigendian; (* winsize *)
      checksum    : 16 : bigendian;
      _           : 16 : bigendian; (* urgptr *)
      _           : (offset - 5) * 32 : bitstring; (* options *)
      payload     : -1 : bitstring
    } ->
      let seqnum = Int32.to_int_exn seq in
      let acknum = Int32.to_int_exn ack in
      let length = Bitstring.bitstring_length payload in
      Some { source; destination; seqnum; acknum; length; checksum }
  | { _ } -> None

let to_string v =
  Printf.sprintf "TCP:(%5d -> %5d, %5d)" v.source v.destination v.length

