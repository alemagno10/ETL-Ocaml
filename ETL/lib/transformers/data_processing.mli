type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: char;
}
type pro = {
  order_id: int;
  amount: float;
  tax_amount: float;
}

type item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
}

val filter_by :  string -> char -> order list -> order list
val group_by_order_id : pro list -> pro list
val item_amount_processing : item -> pro