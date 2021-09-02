# 1. Deduplicate

To run tests:
`npx elm-test`

# 2. Cars

Schema for tables:

    CREATE TABLE `car` (
        `id` int not null PRIMARY KEY,
        `lender_id` int not null
    );
    CREATE TABLE `car_availability` (
        `id` int not null PRIMARY KEY,
        `car_id` int not null,
        `from` datetime not null,
        `to` datetime not null
    );
    CREATE TABLE `user` (
        `id` int not null PRIMARY KEY
    );
    CREATE TABLE `user_bookings` (
        `id` int not null PRIMARY KEY,
        `user_id` int not null,
        `car_id` int not null,
        `from` datetime not null,
        `to` datetime not null
    );

I would also add indices depending on what common queries are needed.




Relations: 
- each card belongs to a lender, a lender can lend multiple cars
- car availability has slots which do not touch or overlap (these can be combined if they come up when adding)
- no two user bookings for the same car_id can overlap

Query for finding available cars for a timeslot 'from', 'to' (pseudocode)

    select c.id as car_id, count(ub.id where ub.id is not null) as overlapping_bookings
    from cars c join
      car_availability ca on c.id = ca.car_id join 
      user_bookings ub on (
        ub.id = ca.user_id and 
        !((ub.from <= {from} and ub.to <= {to}) or
        (ub.from >= {from} and ub.to >= {to})) # excluding non-overlapping slots
      )
    where
      ca.from <= {from} and ca.to >= {to}
    group by c.id
    having count(ub.id) = 0

Comparison with other solutions:
You could simplify the approach using discrete timeslots whether by hour, by day etc - but the one I outlined allows high flexibility of timeslots. I also considered storing available timeslots with bookings subtracted, already showing a complete availability picture but it becomes messy to manage, makes more sense to keep availability and bookings seperate and then layer them up when querying



# 3. Frontops

I would use a docker file with two FROM statements e.g.

    FROM xxxx as staging
    WORKDIR xxx
    RUN xxx
    COPY xxx
    RUN xxx

    FROM xxxx as production
    WORKDIR xxx
    RUN xxx
    COPY --from=staging
    RUN xxx

This also enables deploying just staging by e.g. running `docker build --target staging `
I would have config files with ENV variables for each environment so when running for a different FQDN in eg staging I would change in the staging config file

For a change in API, it depends how the API change is rolled out. For example, if it was via a new FQDN I'd change that and any code changes needed for staging only and once tested move to production. If the API change is known to be sudden with no way to roll over, if possible I'd make the code be able to handle both versions for the transition. 
