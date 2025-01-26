config = {}

config.debug = true
config.society = "syn_society" -- mega_companies or syn_society
config.webhook = "" -- Webhook for the payments 

--Billing--
config.billJob = {
    "val_doctor", 
    "str_doctor",
    "arma_doctor",
    "sd_doctor",
    "tw_doctor",
}
config.billCommission = 0.1 -- commission for the bill /bill you will get 10% of the bill for the player who is using /bill command the rest will go to the society
config.billCommand = "bill" -- command for the bill /bill
config.timer = 30 --time in minutes to get paycheck


config.paycheckJob = { 
    doctor ={
        job = "doctor",
        pay = {
            {grade = 0, paycheck = 9},
            {grade = 1, paycheck = 11},
            {grade = 2, paycheck = 13},
            {grade = 3, paycheck = 15},
            {grade = 4, paycheck = 18},
            {grade = 5, paycheck = 20},
            {grade = 6, paycheck = 25},

        }
    },
    unemployed ={
        job = "unemployed",
        pay = {
            {grade = 0, paycheck = 2},
            {grade = 1, paycheck = 2},

        }
    },
}
