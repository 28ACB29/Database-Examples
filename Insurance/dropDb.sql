--
-- Drop schema for CS4332 Project
--

-- Give user some feedback

set termout on
prompt Clearing database.
set termout off
set feedback on

-- Remove any existing tables

drop table Party cascade constraints;
drop table Client cascade constraints;
drop table Employee cascade constraints;
drop table Claimant cascade constraints;
drop table Policy cascade constraints;
drop table Holds cascade constraints;
drop table UnderWritingAction cascade constraints;
drop table CoveredItem cascade constraints;
drop table Coverage cascade constraints;
drop table Covers cascade constraints;
drop table RatingAction cascade constraints;
drop table Claim cascade constraints;
drop table ClaimAction cascade constraints;