const config = require("config");
const axios = require("axios");
const Promise = require("bluebird");

const makeRequest = async function(userCount, requestCount) {
    // sign-in, make reservation, sign-out
    try {
        const signInResponse = await axios({
            method: "post",
            url: "http://localhost:3000/signin",
            headers: {
                "Content-Type": "application/json"
            },
            data: {
                email: `guest#${userCount}@knowmanshow.com`,
                password: "password"
            }
        }, {
            withCredentials: true   
        })

        console.log(`User: ${userCount} :: Request :: ${requestCount} :: sign-in done`);
        console.log(`User: ${userCount} :: Request :: ${requestCount} :: requesting create reservation`);

        await axios({
            method: "post",
            url: "http://localhost:3000/halls/2/shows/3/reservations",
            headers: {
                "Content-Type": "application/json",
                "Cookie": signInResponse["headers"]["set-cookie"]
            },
            data: {
                reservation: {
                    total_seats: 7
                }
            },
            withCredentials: true
        })

        console.log(`User: ${userCount} :: Request :: ${requestCount} :: create reservation done`);
        console.log(`User: ${userCount} :: Request :: ${requestCount} :: requesting sign-out`);

        await axios({
            method: "delete",
            url: "http://localhost:3000/signout",
            headers: {
                "Content-Type": "application/json",
                "Cookie": signInResponse["headers"]["set-cookie"]
            },
            withCredentials: true
        })

        console.log(`User: ${userCount} :: Request :: ${requestCount} :: sign-out done`);
    }
    catch(err) {
        console.log(`User: ${userCount} :: Request :: ${requestCount} :: failed :: status code :: ${err.status} :: status text :: ${err.statusText}`);
    }
}

const main = async function() {
    const userCount = config.get("users-count");
    const requestCount = config.get("requests-count");
    
    const makeRequestAsync = Promise.promisify(makeRequest)
    const promises = [];
    
    for(let idx = 0; idx < userCount; idx++) {
        for(let idy = 0; idy < requestCount; idy++) {
            promises.push(makeRequestAsync(idx + 1, idy + 1));
        }
    }   

    await Promise.all(promises)
    
    console.log("Done");
    
    process.exit()
}

main();