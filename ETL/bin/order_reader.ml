open Types

(** Parses a single row from a CSV file and converts it into an [order] record.
  @param row A list of strings representing a row from the CSV.
  @return An [order] record parsed from the row. If the row is invalid, 
    a default item with zero values is returned. *)
let parse_order_row (row: string list): order =
  match row with 
  | [id; client_id; order_date; status; origin] ->
    let id = int_of_string id in
    let client_id = int_of_string client_id in
    let origin_char = origin.[0] in
    {id; client_id; order_date; status; origin = origin_char} 
  | _ -> 
    Printf.printf "Skipping invalid row: %s\n" (String.concat ", " row);
    { id = 0; client_id = 0; order_date = ""; status = ""; origin = ' ' } 
      
    
(** Reads a CSV file and parses its content into a list of [order] records.
  @param filename The path to the CSV file.
  @return A list of [order] records, skipping invalid rows. *)
let read_order_csv filename =
  let data = Csv.load filename in
  let rows = List.tl data in
  List.map parse_order_row rows

