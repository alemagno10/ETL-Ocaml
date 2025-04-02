open Lwt
open Cohttp
open Cohttp_lwt_unix

(** 
  Downloads a CSV file from a given URL and saves it locally.
  @param url The URL of the CSV file.
  @param filename The name of the local file to save.
*)
let rec download_csv (url: string) (filename: string) : unit Lwt.t =
  let uri = Uri.of_string url in
  Client.get uri >>= fun (resp, body) ->
  match Response.status resp with
  | `OK ->
      Cohttp_lwt.Body.to_string body >>= fun body_str ->
      Lwt_io.with_file ~mode:Lwt_io.Output filename (fun oc ->
        Lwt_io.write oc body_str)
  | `See_other | `Found | `Moved_permanently | `Temporary_redirect | `Permanent_redirect ->
      (match Cohttp.Header.get (Response.headers resp) "location" with
       | Some new_url -> download_csv new_url filename
       | None -> Lwt.fail_with "Redirection without Location header")
  | status ->
      let error_msg = Printf.sprintf "Failed to download CSV. HTTP status: %s"
        (Code.string_of_status status) in
      Lwt.fail_with error_msg

(** 
  Downloads two CSV files from specified URLs and saves them with given filenames.
  @param filename1 The name of the local file to save the first CSV.
  @param filename2 The name of the local file to save the second CSV.
  @return A Lwt thread that resolves when both files have been downloaded.
*)
let download_files (filename1: string) (filename2: string) = 
  let url1 = "https://drive.google.com/uc?export=download&id=1EgluEBtcbyxj9bM9Efu1LPdmf-k_Q9dJ" in  
  let url2 = "https://drive.google.com/uc?export=download&id=1CfGjd9qBjJQtzXGtIxE6EB4CjVftmhKp" in
  Lwt.join [download_csv url1 filename1; download_csv url2 filename2]
;;
