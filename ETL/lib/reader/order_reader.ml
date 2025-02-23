type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: char;
}

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
      
let read_order_csv filename =
  let data = Csv.load filename in
  let rows = List.tl data in
  List.map parse_order_row rows

