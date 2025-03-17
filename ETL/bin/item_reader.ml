open Types

(** Parses a single row from a CSV file and converts it into an [item] record.
  @param row A list of strings representing a row from the CSV.
  @return An [item] record parsed from the row. If the row is invalid, 
    a default item with zero values is returned. *)
let parse_item_row (row: string list) : item =
  match row with 
  | [order_id; product_id; quantity; price; tax] ->
    let order_id = int_of_string order_id in
    let product_id = int_of_string product_id in
    let quantity = int_of_string quantity in
    let price = float_of_string price in
    let tax = float_of_string tax in
    { order_id; product_id; quantity; price; tax } 
  | _ -> 
    Printf.printf "Skipping invalid row: %s\n" (String.concat ", " row);
    { order_id = 0; product_id = 0; quantity = 0; price = 0.; tax = 0. } 


(** Reads a CSV file and parses its content into a list of [item] records.
  @param filename The path to the CSV file.
  @return A list of [item] records, skipping invalid rows. *)
let read_item_csv (filename: string) : item list =
  let data = Csv.load filename in
  let rows = List.tl data in
  List.map parse_item_row rows ;;
  