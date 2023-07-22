octolib.registerTests({
	name = 'Basic database usage',
	run = function(finish)
		octolib.func.chain({
			function(done)
				octolib.db:RunQuery('drop table if exists tester')
				octolib.db:RunQuery('create table if not exists tester(id varchar(32))', done)
			end,
			function(done, q, st, data)
				octolib.db:PrepareQuery('insert into tester(id) values(?)', {'it works'}, done)
			end,
			function(done)
				octolib.db:RunQuery('select * from tester', done)
			end,
			function(done, q, st, data)
				finish(data[1].id ~= 'it works' and 'Data mismatch')
			end,
		})
	end,
}, 'octolib')
