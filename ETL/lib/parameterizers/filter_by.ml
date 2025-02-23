(* (status: string origin: char): list *)

let filter_by_status_and_origin o status origin = 
  o.status status && o.origin = origin

let filter_by status origin order = 
  List.filter filter_by_status_and_origin order

