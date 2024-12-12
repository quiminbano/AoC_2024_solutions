use is_sorted::IsSorted;
use std::cmp::Ordering;
use std::fs::File;
use std::io::{self, BufRead, BufReader, Lines};
use std::process::ExitCode;

fn main() -> ExitCode {
    let file;
    let lines_file: Lines<BufReader<File>>;
    let mut count_safe: u64;
    let mut numbers: Vec<u64>;
    let mut vector_size: usize;
    let mut temp_vec: Vec<u64>;
    let mut pos_remove: usize;

    count_safe = 0;
    numbers = Vec::new();
    temp_vec = Vec::new();
    file = match File::open("database.csv") {
        Ok(file) => file,
        Err(_) => {
            eprintln!("Error trying to open database.csv");
            return ExitCode::FAILURE;
        }
    };
    lines_file = io::BufReader::new(file).lines();
    for line in lines_file.flatten() {
        numbers.clear();
        if let Ok(result_vec) = parse_lines(&line) {
            numbers = result_vec;
        } else {
            eprintln!("Error trying to parse database.csv");
            return ExitCode::FAILURE;
        }
        if is_safe(&numbers) {
            count_safe += 1;
            continue;
        }
        pos_remove = 0;
        vector_size = numbers.len();
        while pos_remove < vector_size {
            temp_vec.clear();
            temp_vec = numbers.clone();
            temp_vec.remove(pos_remove);
            if is_safe(&temp_vec) {
                count_safe += 1;
                break;
            }
            pos_remove += 1;
        }
    }
    println!("The ammount of safe reports is, {}", count_safe);
    return ExitCode::SUCCESS;
}

fn parse_lines(line: &String) -> Result<Vec<u64>, String> {
    let numbers_as_str: Vec<&str>;
    let mut numbers: Vec<u64>;

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
    return Ok(numbers);
}

fn is_safe(parsered_vec: &Vec<u64>) -> bool {
    let ordered: bool;
    let reversed_ordered: bool;

    ordered = IsSorted::is_sorted(&mut parsered_vec.iter());
    reversed_ordered = IsSorted::is_sorted_by(&mut parsered_vec.iter(), decr);
    if !ordered && !reversed_ordered {
        return false;
    }
    if ordered && !check_ordered(parsered_vec) {
        return false;
    } else if reversed_ordered && !check_reversed_ordered(parsered_vec) {
        return false;
    }
    return true;
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
