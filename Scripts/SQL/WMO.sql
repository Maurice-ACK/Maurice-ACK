USE [default];

select * from [SWVO$ACKWMOPrestatie$38b9bfb5-e282-431c-b25b-2c85c7970c47]
select * from [SWVO$ACKWMOHeader$38b9bfb5-e282-431c-b25b-2c85c7970c47]
select * from [CRONUS NL$ACKWMOHeader$38b9bfb5-e282-431c-b25b-2c85c7970c47]
select * from [CRONUS NL$ACKWMOClient$38b9bfb5-e282-431c-b25b-2c85c7970c47]

select * from [CRONUS NL$ACKHealthcareMonth$38b9bfb5-e282-431c-b25b-2c85c7970c47]
select * from [CRONUS NL$ACKProductCodeRate$38b9bfb5-e282-431c-b25b-2c85c7970c47]

--Clients
select * from [CRONUS NL$ACKClient$38b9bfb5-e282-431c-b25b-2c85c7970c47]

-- Addresses
select * from [CRONUS NL$ACKClientAddress$38b9bfb5-e282-431c-b25b-2c85c7970c47]

-- Indications
select * from [CRONUS NL$ACKWMOIndication$38b9bfb5-e282-431c-b25b-2c85c7970c47]

-- Setup tables
-- General setup
select [$systemId], * from [CRONUS NL$ACKSWVOGeneralSetup$38b9bfb5-e282-431c-b25b-2c85c7970c47]

-- Retour codes
select [$systemId], * from [ACKWMORetourCode$38b9bfb5-e282-431c-b25b-2c85c7970c47] 

--StUF
select * from [CRONUS NL$ACKStUF$38b9bfb5-e282-431c-b25b-2c85c7970c47]

-------------- 301 & 302 --------------

--Header
select [$systemId], * from [CRONUS NL$ACKWMOHeader$38b9bfb5-e282-431c-b25b-2c85c7970c47]

--Client
select [$systemId], * from [CRONUS NL$ACKWMOClient$38b9bfb5-e282-431c-b25b-2c85c7970c47]

 --Relatie
select [$systemId], * from [CRONUS NL$ACKWMORelatie$38b9bfb5-e282-431c-b25b-2c85c7970c47]

--Contact
select [$systemId], * from [CRONUS NL$ACKWMOContact$38b9bfb5-e282-431c-b25b-2c85c7970c47] 

--ToegewezenProduct
select [$systemId], * from [CRONUS NL$ACKWMOToegewezenProduct$38b9bfb5-e282-431c-b25b-2c85c7970c47] 

--Message retour codes
select [$systemId], * from [CRONUS NL$ACKWMOMessageRetourCode$38b9bfb5-e282-431c-b25b-2c85c7970c47] 

-------------- 305 & 306 & 307 & 308 --------------

--Header
select [$systemId], * from [CRONUS NL$ACKWMOHeader$38b9bfb5-e282-431c-b25b-2c85c7970c47]
where BerichtCode = 418 or BerichtCode = 419 or BerichtCode = 420 or BerichtCode = 421

--Client
select [$systemId], * from [CRONUS NL$ACKWMOClient$38b9bfb5-e282-431c-b25b-2c85c7970c47]


--Start product
select [$systemId], * from [CRONUS NL$ACKWMOStartStopProduct$38b9bfb5-e282-431c-b25b-2c85c7970c47]


-------------- 317 --------------
--Header
select [$systemId], * from [CRONUS NL$ACKWMOHeader$38b9bfb5-e282-431c-b25b-2c85c7970c47]
where BerichtCode = 418 or BerichtCode = 419 or BerichtCode = 420 or BerichtCode = 421

--Client
select [$systemId], * from [CRONUS NL$ACKWMOClient$38b9bfb5-e282-431c-b25b-2c85c7970c47]


--Start product
select [$systemId], * from [CRONUS NL$ACKWMOStartStopProduct$38b9bfb5-e282-431c-b25b-2c85c7970c47]

select * from [CRONUS NL$ACKNewChangedUnchangedProduct$38b9bfb5-e282-431c-b25b-2c85c7970c47]

-- Update scripts

--Update contactt
--select * from [CRONUS NL$ACKWMOContact$38b9bfb5-e282-431c-b25b-2c85c7970c47] 
--update [CRONUS NL$ACKWMOContact$38b9bfb5-e282-431c-b25b-2c85c7970c47] 
--set ValidFrom = CAST('2021-02-01' AS DATETIME)
--where Id = 1

--update [CRONUS NL$ACKWMOHeader$38b9bfb5-e282-431c-b25b-2c85c7970c47]
--set Afzender = '10000'

-- Address
--update [CRONUS NL$ACKClientAddress$38b9bfb5-e282-431c-b25b-2c85c7970c47]
--set ValidFrom = CAST('2021-02-01' AS DATETIME),
--Street = 'Andere plaats',
--Postcode = '888BYY'
--where Id = 5


--update [CRONUS NL$ACKWMOClient$38b9bfb5-e282-431c-b25b-2c85c7970c47]
--set  SSN = '9999000'


