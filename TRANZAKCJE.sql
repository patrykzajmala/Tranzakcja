USE 1kl_1;

SELECT 
    ROW_NUMBER() OVER (ORDER BY cl.id, ca.id) AS ID_ubezpieczenia,
    cl.id AS ID_klienta,
    ca.id AS ID_samochodu,

    CASE 
        WHEN ca.rok BETWEEN 2000 AND 2015 THEN 2500
        WHEN ca.rok BETWEEN 1980 AND 1990 THEN 2200
        WHEN ca.rok BETWEEN 1940 AND 1979 THEN 1300
        ELSE 3000
    END AS cena_bazowa_zl,

    ROUND(
        ( CASE 
                WHEN ca.rok BETWEEN 2000 AND 2015 THEN 2500
                WHEN ca.rok BETWEEN 1980 AND 1999 THEN 2200
                WHEN ca.rok BETWEEN 1940 AND 1979 THEN 1300
            END) 
        * 
        (
            1 
            - IF(cl.country IN ('Poland', 'China'), 0.3, 0)
            + IF(cl.email LIKE '%apple%', 0.4, 0)
        )
        * 
        (
            1 - (0.05 * ( (SELECT COUNT(*) FROM car WHERE client_id = cl.id) - 1 ))
        )
    , 2) AS cena_koncowa_zl

FROM car ca 
JOIN clients cl ON ca.client_id = cl.id
LIMIT 0, 25;
