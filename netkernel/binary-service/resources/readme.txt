/*
ToDo Peter:

Need to define the following as a new stand-alone module of REST services
to implement a Binary Store (use /binstore as overlay URL root).  This service
should be as generic as possible, not specific to IOPs needs.
ToDo: Create Apiary spec for this as well

Need a config facility in the main /iop service to lookup the location of the BinStore service
Need a config facility in the /binstore service to configure where files should go and other aspects
Want to abstract this so that storage could be local disk, MarkLogic, NAS/SAN, AWS EC2, Akamai, etc.

Individual binaries, minimum needed to support IOP content service

PUT /binary/id/{uri}
	Content-Type: {mime type}   // could affect where binary is ultimately stored
	Needs to record internally, in some way, a mapping from {uri} to actual location
		(uri is location independent, actual location should never be exposed)
	return 201 on success

GET /binary/id/{uri}
	Content-Type: {mime-type}
	Content-Length: {size}
	X-Hash: hash of content, computed on PUT
	Given a URI, retrieve the bag-of-bits and return it as the body.  The mime-type and size
	should be as stored by the PUT call
	return 200 or 404

HEAD /binary/id/{uri}
	Same a GET, with empty body.  To be used to fetch meta-info to check if a given binary has actually changed.

DELETE /binary/id/{uri}
	Given a uri (which is location independent) make the bag-of-bits go away and remove the associated metadata


Advanced functionality, if we get ambitious:

POST /binary/transaction
	ETag: Entity Tag (random unique hash)
	X-Transaction-ID: 12345   (maybe allocated by identifier service?)

GET /binary/transaction/id/{transaction-id}
	ETag: {etag}
	body -> XML representation of accumulated PUTs and DELETES for this transaction, state of the transaction itself

Perform updates in the context of the transaction

PUT /binary/id/{uri}/{transaction-id}
	Places the binary in an isolated location or otherwise hides it from non-transactional access
	Updates the transaction state to include the new binary and its metadata

DELETE /binary/id/{uri}/{transaction-id}
	Marks binary for deletion, but does not actually modify it
	Updates the transaction state to include the that will be deleted

Resolve the transaction

DELETE /binary/transaction/id/{transaction-id}
	Roll back, the transaction state is discarded (transaction id no longer valid)
	(may want to record this info as history somewhere, to record that a rollback happened)
	Any binaries PUT on he transaction are removed.

PUT /binary/transaction/id/{transaction-id}
	ETag: {etag}
	Commit accumulated updates in transaction.  ETag must also validate.
	Body can be empty, or possibly contain a note or additional information, such as content bundle ID
	Transaction state is updated, possibly including info in the PUT body, then marked as read-only.  It
	is possible to GET it thereafter, but not DELETE or PUT it again.

GET /binary/info
	Return a summary (XML or JSON) of number of files stored, total space used, percentage of total used, etc

 */
