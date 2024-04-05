
let currentSolar;

function getSolarData() {
    var solarResult;
    let ajaxPromise = apex.server.process("getCurrentSolar");
    
    ajaxPromise.done(function (data) { 
        solarResult = data }
                                
        ).fail( function ( jqXHR, textStatus, errorThrown ) 
        {
            console.log("jqXHR: ", jqXHR);
            console.log("textStatus: ", textStatus);
            console.log("errorThrown: ", errorThrown) });

    return solarResult;
};
let logSolar = function logSolar() {
    let currentSolar = getSolarData();
    console.log("currentSolar: ", currentSolar);

};


logSolar();

setInterval(
    logSolar, 5 * 60 * 1000); // 5 minutes in milliseconds

