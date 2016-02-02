open Bitstring
open Core.Std

type t = {
  source      : int;
  destination : int;
  length      : int;
  checksum    : int;
}

val decode : Bitstring.t -> t option
val to_string : t -> string