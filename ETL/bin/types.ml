type item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
}

type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: char;
}

type combined = 
  Joined of { order: order; item: item}

type output = {
  order_id: int;
  amount: float;
  tax_amount: float;
}

type monthly_output = {
  amount: float;
  date_of_order: string;
  tax_amount: float;
}
  