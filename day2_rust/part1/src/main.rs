use is_sorted::IsSorted;
use std::cmp::Ordering;
use std::fs::File;
use std::io::{self, BufRead, BufReader, Lines};
use std::process::ExitCode;

fn main() -> ExitCode {
    let file;
    let lines_file: Lines<BufReader<File>>;
    let mut count_safe: u64;

    count_safe = 0;
    file = match File::open("database.csv") {
        Ok(file) => file,
        Err(_) => {
            eprintln!("Error trying to open database.csv");
            return ExitCode::FAILURE;
        }
    };
    lines_file = io::BufReader::new(file).lines();
    for line in lines_file.flatten() {
        if let Ok(result_bool) = is_safe(&line) {
            if result_bool {
                count_safe += 1;
            }
        } else {
            eprintln!("Error trying to parse database.csv");
            return ExitCode::FAILURE;
        }
    }
    println!("The ammount of safe reports is, {}", count_safe);
    return ExitCode::SUCCESS;
}

fn is_safe(line: &String) -> Result<bool, String> {
    let numbers_as_str: Vec<&str>;
    let mut numbers: Vec<u64>;
    let ordered: bool;
    let reversed_ordered: bool;

    numbers = Vec::new();
    numbers_as_str = line.split_whitespace().collect();
    for number_str in numbers_as_str {
        match number_str.parse::<u64>() {
            Ok(number) => numbers.push(number),
            Err(_) => {
                return Err("".to_string());
            }
        };
    }
    ordered = IsSorted::is_sorted(&mut numbers.iter());
    reversed_ordered = IsSorted::is_sorted_by(&mut numbers.iter(), decr);
    if !ordered && !reversed_ordered {
        return Ok(false);
    }
    if ordered && !check_ordered(&numbers) {
        return Ok(false);
    } else if reversed_ordered && !check_reversed_ordered(&numbers) {
        return Ok(false);
    }
    return Ok(true);
}

fn check_ordered(numbers: &Vec<u64>) -> bool {
    let size_vector: usize;
    let mut iter: usize;
    let mut prev: u64;
    let mut current: u64;

    iter = 1;
    size_vector = numbers.len();
    if size_vector <= 1 {
        return false;
    }
    prev = numbers[0];
    while iter < size_vector {
        current = numbers[iter];
        if (current - prev) < 1 || (current - prev) > 3 {
            return false;
        }
        prev = current;
        iter += 1;
    }
    return true;
}

fn check_reversed_ordered(numbers: &Vec<u64>) -> bool {
    let size_vector: usize;
    let mut iter: usize;
    let mut prev: u64;
    let mut current: u64;

    iter = 1;
    size_vector = numbers.len();
    if size_vector <= 1 {
        return false;
    }
    prev = numbers[0];
    while iter < size_vector {
        current = numbers[iter];
        if (prev - current) < 1 || (prev - current) > 3 {
            return false;
        }
        prev = current;
        iter += 1;
    }
    return true;
}

fn decr<T: PartialOrd>(a: &T, b: &T) -> Option<Ordering> {
    a.partial_cmp(b).map(|v| v.reverse())
}
