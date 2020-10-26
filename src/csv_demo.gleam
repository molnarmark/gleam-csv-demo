import gleam/io
import gleam/string
import gleam/list
import gleam/map
import gleam/result
import gleam/option.{None, Some}

const test_csv_input = "firstname;lastname;address;city;state;zip
John;Doe;120 jefferson st.;Riverside;NJ;08075
Jack;McGinnis;220 hobo Av.;Phila;PA;09119
Joan;Jet;9th Terrace plc;Desert City;CO;00123"

pub type CSVRow {
  CSVRow(val: map.Map(String, String))
}

pub type CSVDocument {
  CSVDocument(headers: List(String), rows: List(CSVRow))
}

fn parse_row(headers: List(String), row: String, delimiter: String) -> CSVRow {
  row
  |> string.split(delimiter)
  |> list.index_map(fn(i, row_val) {
    let header =
      headers
      |> list.at(i)

    tuple(result.unwrap(header, "Err"), row_val)
  })
  |> map.from_list
  |> CSVRow
}

pub fn get_row(csv: CSVDocument, index: Int) {
  list.at(csv.rows, index)
}

// pub fn get_value(row: CSVRow, name: String) -> String {
//   // row.val
//   // |> map.get(name)
// }
pub fn parse(input: String, delimiter: String) -> CSVDocument {
  let raw_rows =
    input
    |> string.split("\n")

  let headers =
    result.unwrap(list.head(raw_rows), "")
    |> string.split(delimiter)

  let rows =
    result.unwrap(list.tail(raw_rows), [])
    |> list.map(fn(row) { parse_row(headers, row, delimiter) })

  CSVDocument(headers, rows)
}

pub fn main(_) {
  let csv = parse(test_csv_input, ";")
  let first_row = result.unwrap(get_row(csv, 1), Nil)
  io.debug(first_row)
  // io.debug(get_value(first_row, "hello"))
}
