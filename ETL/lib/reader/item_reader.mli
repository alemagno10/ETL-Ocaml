type item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
}

val read_item_csv : string -> item list