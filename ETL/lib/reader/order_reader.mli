type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: char;
}

val read_order_csv : string -> order list