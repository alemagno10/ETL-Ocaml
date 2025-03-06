type item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
}

type pro = {
  order_id: int;
  amount: float;
  tax_amount: float;
}

type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: char;
}
