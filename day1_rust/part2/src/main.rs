use std::fs::File;
use std::io::{self, BufRead, BufReader, Lines};
use std::process::ExitCode;

fn main() -> ExitCode {
    let file;
    let mut first_column: Vec<i64>;
    let mut second_column: Vec<i64>;
    let result: i64;

    file = match File::open("database.csv") {
        Ok(file) => file,
        Err(_) => {
            eprintln!("Error trying to open database.csv");
            return ExitCode::FAILURE;
        }
    };
    (first_column, second_column) = match get_vectors(&file) {
        Ok(tuple) => tuple,
        Err(error_string) => {
            eprintln!("{}", error_string);
            return ExitCode::FAILURE;
        }
    };
    first_column.sort();
    second_column.sort();
    result = get_result(&first_column, &second_column);
    println!("The result is: {}", result);
    return ExitCode::SUCCESS;
}

fn get_vectors(file: &File) -> Result<(Vec<i64>, Vec<i64>), String> {
    let mut first_column: Vec<i64>;
    let mut second_column: Vec<i64>;
    let buffer: Lines<BufReader<&File>>;

    buffer = io::BufReader::new(file).lines();
    first_column = Vec::new();
    second_column = Vec::new();
    for line in buffer.flatten() {
        if let Ok((x, y)) = extract_numbers(&line) {
            first_column.push(x);
            second_column.push(y);
        } else {
            return Err("Error procesing the content of the file".to_owned());
        };
    }
    return Ok((first_column, second_column));
}

fn extract_numbers(line: &String) -> Result<(i64, i64), String> {
    let arguments: Vec<&str>;
    let number1: i64;
    let number2: i64;

    arguments = line.split_whitespace().collect();
    if arguments.len() != 2 {
        return Err("".to_owned());
    }
    number1 = match arguments[0].parse::<i64>() {
        Ok(number1) => number1,
        Err(_) => {
            return Err("".to_owned());
        }
    };
    number2 = match arguments[1].parse::<i64>() {
        Ok(number2) => number2,
        Err(_) => {
            return Err("".to_owned());
        }
    };
    return Ok((number1, number2));
}

fn get_result(first_column: &Vec<i64>, second_column: &Vec<i64>) -> i64 {
    let mut result: i64;
    let mut temp: usize;
    let mut mul_result: i64;

    result = 0;
    for member in first_column {
        temp = second_column.into_iter().filter(|&n| *n == *member).count();
        mul_result = *member;
        mul_result = mul_result.saturating_mul(temp as i64);
        result = result.saturating_add(mul_result);
    }
    return result;
}
