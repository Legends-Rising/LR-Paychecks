# LR-Paychecks

A comprehensive RedM resource for managing paychecks, billing, and society funds. Created by Legends Studio.

## Features

### 1. Automated Paychecks
- Configurable payment intervals
- Different pay scales based on job and grade
- Automatic paycheck distribution
- Discord webhook notifications for payments

### 2. Billing System
- `/bill` command for authorized jobs
- Commission-based billing (configurable percentage)
- Interactive billing menu using Feather Menu
- Two-way confirmation system for bills
- Protection against excessive billing (minimum balance protection)

### 3. Society Integration
- Support for multiple society systems:
  - Mega Companies
  - Syn Society
- Automatic fund distribution to society accounts
- Commission splitting between biller and society

### 4. Configuration Options
- Customizable debug mode
- Configurable billing jobs
- Adjustable commission rates
- Customizable payment intervals
- Flexible job grade payment scales
- Discord webhook integration

## Dependencies
- VORP Core
- Feather Menu
- Mega Companies (optional)
- Syn Society (optional)

## Installation

1. Ensure you have all dependencies installed
2. Copy the resource to your resources folder
3. Add `ensure lr-paychecks` to your `server.cfg`
4. Configure the `config.lua` file to your needs

## Configuration

### Main Configuration (`config.lua`)
```lua
config = {
    debug = true,                    -- Enable/disable debug mode
    society = "syn_society",         -- Choose society system (mega_companies or syn_society)
    webhook = "",                    -- Discord webhook URL for notifications
    billCommission = 0.1,           -- Commission rate for billing (10%)
    billCommand = "bill",           -- Command to open billing menu
    timer = 30                      -- Paycheck interval in minutes
}
```

### Job Configuration
Configure different jobs and their pay grades in `config.lua`:
```lua
config.paycheckJob = {
    doctor = {
        job = "doctor",
        pay = {
            {grade = 0, paycheck = 9},
            {grade = 1, paycheck = 11},
            -- Add more grades as needed
        }
    }
    -- Add more jobs as needed
}
```

### Authorized Billing Jobs
Configure which jobs can use the billing system:
```lua
config.billJob = {
    "val_doctor",
    "str_doctor",
    -- Add more jobs as needed
}
```

## Usage

### For Players
- Paychecks are automatically received based on the configured interval
- Players will receive notifications when they get paid

### For Authorized Jobs
1. Use `/bill` command to open billing menu
2. Enter target player ID and amount
3. Confirm the billing details
4. Target player will receive a confirmation prompt
5. Once confirmed, funds are distributed between society and biller

## Contributing 🤝
- Feel free to open issues or submit pull requests with suggestions/fixes.
