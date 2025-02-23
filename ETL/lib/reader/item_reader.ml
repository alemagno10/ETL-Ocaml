type item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
}

let parse_item_row (row: string list) : item =
  match row with 
  | [order_id; product_id; quantity; price; tax] -> 
    {
      order_id = int_of_string order_id; 
      product_id = int_of_string product_id; 
      quantity = int_of_string quantity; 
      price = float_of_string price; 
      tax = float_of_string tax;
    } 
  | _ -> 
      Printf.printf "Skipping invalid row: %s\n" (String.concat ", " row);
      { order_id = 0; product_id = 0; quantity = 0; price = 0.; tax = 0. } 

let read_item_csv filename =
  let data = Csv.load filename in
  let rows = List.tl data in
  List.map parse_item_row rows