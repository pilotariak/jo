-- Copyright (C) 2016-2019 Nicolas Lamirault <nicolas.lamirault@gmail.com>

-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

CREATE TABLE IF NOT EXISTS league (
  league_id    INT PRIMARY KEY,
  name         STRING(100),
  keyword      STRING(100),
  address      TEXT,
  website      STRING(150),
  email        STRING(150),
  phone_number STRING(150),
  created_at   TIMESTAMPZ,
  updated_at   TIMESTAMPZ,
  deleted_at   TIMESTAMPZ,
  INDEX (name)
);


CREATE TABLE IF NOT EXISTS challenge (
  challenge_id INT PRIMARY KEY,
  name         STRING(100),
  keyword      STRING(100),
  created_at   TIMESTAMPZ,
  updated_at   TIMESTAMPZ,
  deleted_at   TIMESTAMPZ,
  INDEX (name),
  INDEX (keyword)
);


CREATE TABLE IF NOT EXISTS discipline (
  discipline_id INT PRIMARY KEY,
  name          STRING(100),
  keyword       STRING(100),
  created_at    TIMESTAMPZ,
  updated_at    TIMESTAMPZ,
  deleted_at    TIMESTAMPZ,
  INDEX (name),
  INDEX (keyword)
);


CREATE TABLE IF NOT EXISTS level (
  league_id  INT,
  name       STRING(40),
  keyword    STRING(100),
  created_at TIMESTAMPZ,
  updated_at TIMESTAMPZ,
  deleted_at TIMESTAMPZ,
  INDEX (name),
  INDEX (keyword)
);


-- =======================================================================================
-- Init

INSERT INTO league (name, keyword, address, website, email, phone_number, created_at)
VALUES (
  "LIGUE DE PELOTE BASQUE DE CÔTE D’ARGENT",
  "lcapb",
  "Maison Départementale des Sports 153, rue David Johnston 33000 Bordeaux",
  "http://www.lcapb.net",
  "contact@lcapb.net",
  "+335 56 00 99 15",
  now());

