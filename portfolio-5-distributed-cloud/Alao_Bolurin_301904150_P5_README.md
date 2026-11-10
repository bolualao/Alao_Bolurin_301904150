# Portfolio 5 Distributed and Cloud Database Exercise

## Current setup
The current database runs in a GitHub Codespaces Ubuntu environment alongside PostgreSQL[cite: 32]. It uses MongoDB version 8.0.34 and is launched as a single background process bound to `127.0.0.1` with port forwarding disabled[cite: 32]. The actual topology is not verified as a distributed system; the setup commands indicate a standalone local instance[cite: 32] containing a single `clinic_events` collection with four documents[cite: 31]. 

## Proposed replication
To ensure high availability for the clinic system, I propose transitioning from a standalone instance to a MongoDB replica set. This proposed architecture would include three voting, data-holding members distributed across separate physical hosts or failure zones ([MongoDB Replication](https://www.mongodb.com/docs/manual/replication/)). 

| Member | Starting role | Location |
| :--- | :--- | :--- |
| Node 1 | Primary | Availability Zone A |
| Node 2 | Secondary | Availability Zone B |
| Node 3 | Secondary | Availability Zone C |

In this setup, if a receptionist inserts an `appointment_scheduled` event[cite: 31], the write operation goes to the Primary node. The Secondaries then asynchronously copy this operation to maintain identical data sets.

## Failure and consistency
If the Primary node experiences a failure, the remaining members communicate to hold an election and promote a new Primary ([Replica Set Elections](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/)). During this brief transition, write operations to the clinic database are interrupted. If a network issue isolates the nodes so that a strict majority cannot be reached, the election fails and all surviving nodes operate as read-only Secondaries.

To guarantee data consistency, the clinic application should use "majority" write concern ([Write Concern](https://www.mongodb.com/docs/v8.0/reference/write-concern/)). This ensures an event is only acknowledged as successful once it is safely written to a majority of the nodes. Because Secondaries pull data asynchronously, they may experience temporary replication lag. Reading from a lagged Secondary might return slightly stale patient data until it catches up.

## Sharding and cloud deployment
While replication copies the same data across multiple servers for reliability, sharding splits records horizontally across different servers to manage massive datasets ([Sharding](https://www.mongodb.com/docs/manual/sharding/)). Because the clinic example currently holds only four event documents[cite: 31], it does not require sharding. 

Deploying this proposed architecture on a managed cloud platform like MongoDB Atlas would provide built-in security features, including authentication, data encryption, and network-restricted access, alongside automated tools for cluster backup and restore ([Atlas Backup and Restore](https://www.mongodb.com/docs/atlas/backup-restore-cluster/)). 

However, cloud deployments introduce ongoing financial costs. A key system limitation to note is that MongoDB replication only synchronizes the `clinic_events` collection[cite: 31]. It does not replicate the PostgreSQL relational tables (such as `patient` or `doctor`)[cite: 30], nor does it automatically synchronize data between the two distinct database technologies.