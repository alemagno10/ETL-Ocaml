open Types

(** 
  Creates the necessary tables in the SQLite database if they do not exist.
  @param db The SQLite database connection.
*)
let create_table db =
  let sql_output = "
    CREATE TABLE IF NOT EXISTS output (
      order_id INTEGER PRIMARY KEY,
      amount REAL,
      tax_amount REAL
    );" in
  let sql_monthly_output = "
    CREATE TABLE IF NOT EXISTS monthly_output (
      order_date TEXT PRIMARY KEY,
      amount REAL,
      tax_amount REAL
    );" in

  let stmt = Sqlite3.prepare db sql_output in
  ignore (Sqlite3.step stmt);
  ignore (Sqlite3.finalize stmt);

  let stmt = Sqlite3.prepare db sql_monthly_output in
  ignore (Sqlite3.step stmt);
  ignore (Sqlite3.finalize stmt);
;;


(** 
  Inserts a list of `output` and `monthly_output` records into the SQLite database.
  @param out A list of `output` records to be inserted into the `output` table.
  @param monthly_out A list of `monthly_output` records to be inserted into the `monthly_output` table.
  @param db_filename The filename of the SQLite database.
*)
let to_sqlite (out: output list) (monthly_out: monthly_output list) (db_filename: string) : unit =
  let db = Sqlite3.db_open db_filename in
  create_table db;

  (* Insert into output table *)
  let insert_sql_output = "INSERT INTO output (order_id, amount, tax_amount) VALUES (?, ?, ?);" in
  let stmt_output = Sqlite3.prepare db insert_sql_output in

  List.iter (fun o ->
    ignore (Sqlite3.bind stmt_output 1 (Sqlite3.Data.INT (Int64.of_int o.order_id)));
    ignore (Sqlite3.bind stmt_output 2 (Sqlite3.Data.FLOAT o.amount));
    ignore (Sqlite3.bind stmt_output 3 (Sqlite3.Data.FLOAT o.tax_amount));
    
    ignore (Sqlite3.step stmt_output);
    ignore (Sqlite3.reset stmt_output)
  ) out;

  ignore (Sqlite3.finalize stmt_output);

  (* Insert into monthly_output table *)
  let insert_sql_monthly = "INSERT INTO monthly_output (order_date, amount, tax_amount) VALUES (?, ?, ?);" in
  let stmt_monthly = Sqlite3.prepare db insert_sql_monthly in

  List.iter (fun o ->
    ignore (Sqlite3.bind stmt_monthly 1 (Sqlite3.Data.TEXT o.date_of_order));
    ignore (Sqlite3.bind stmt_monthly 2 (Sqlite3.Data.FLOAT o.amount));
    ignore (Sqlite3.bind stmt_monthly 3 (Sqlite3.Data.FLOAT o.tax_amount));
    
    ignore (Sqlite3.step stmt_monthly);
    ignore (Sqlite3.reset stmt_monthly)
  ) monthly_out;

  ignore (Sqlite3.finalize stmt_monthly);
  ignore (Sqlite3.db_close db)
;;
