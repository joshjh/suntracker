
/* const alarm values */
let intervalID;

const inverterTempWarning = 35;
const batteryTempWarning = 35;
const inverterTempAlarm =42;
const batteryTempAlarm = 30;

const solarindicatorclasses = ["solarindicator"];

function getSolarData() {

    let ajaxPromise = apex.server.process("getCurrentSolar");

    ajaxPromise.done((data) => {
        console.log("data: ", data);
        if (data.success) {
            document.getElementById("solarnow").innerText = `Solar Now:  ${data.SPOWER} W`;
            document.getElementById("inverterstate").innerText = 'Inverter State: '.concat(data.STATUS);
            document.getElementById("invertertemperature").innerText = `Inverter Temperature: ${data.INVERTER_TEMPERATURE} °C`;
            document.getElementById("batterycharge").innerText = `Battery Charge: ${data.BATTERY_CHARGE} %`;
            document.getElementById("batterytemperature").innerText = `Battery Temperature: ${data.BATTERY_TEMPERATURE} °C`;
            
            if (data.INVERTER_TEMPERATURE > inverterTempAlarm) {
                 document.getElementById("invertertemperature").classList.add("u-danger");
             }
            else if (data.INVERTER_TEMPERATURE > inverterTempWarning) {
                document.getElementById("invertertemperature").classList.add("u-warning");
            }
            else {
                document.getElementById("invertertemperature").classList = solarindicatorclasses;
            }

            if (data.BATTERY_TEMPERATURE > batteryTempAlarm) {
                document.getElementById("batterytemperature").classList.add("u-danger");
            }
            else if (data.BATTERY_TEMPERATURE > batteryTempWarning) {
                document.getElementById("batterytemperature").classList.add("u-warning");
            }
            else {
                document.getElementById("batterytemperature").classList = solarindicatorclasses;
            }
            switch (data.STATUS) {
                case "Normal":
                    document.getElementById("inverterstate").classList.add("u-success");
                    break;
              
                case "Unknown":
                    document.getElementById("inverterstate").classList.add("u-warning");
                    break;

                default:
                    document.getElementById("inverterstate").classList = solarindicatorclasses.concat("u-danger");
            }
        }
        else {
            console.log("Error: ajax callback returned something other than success");
            throw new Error("Error: ajax callback returned something other than success");
        }

    })
        .fail(function (jqXHR, textStatus, errorThrown) {
            console.log("jqXHR: ", jqXHR);
            console.log("textStatus: ", textStatus);
            console.log("errorThrown: ", errorThrown);
        });
};

getSolarData();

intervalID = setInterval(
    getSolarData, 5 * 60 * 100); // 5 minutes in milliseconds

