require 'test/unit'
require File.dirname(__FILE__) + "/dpll"

class KnowledgeBaseTest < Test::Unit::TestCase
def test_sti

	stringKb = "p12 AND erren OR NOT p13"
	actualKb = [[1],[2,-3]]
	test1 = KnowledgeBase.new("")
	assert_equal actualKb , test1.string_to_internal(stringKb)
	assert_equal "p12",test1.id_array[0].name
	assert_equal 1,test1.id_array[0].id
	assert_equal test1.total_variables, 4
	
	stringKb = "p11 OR p12 AND not p11 OR not p12"
	actualKb = [[1,2],[-1,-2]]
	test2 = KnowledgeBase.new("")
	assert_equal actualKb, test2.string_to_internal(stringKb)
	assert_equal "p12", test2.id_array[1].name
	assert_equal 2 , test2.id_array[1].id
	assert_equal test2.total_variables, 3

	stringKb = "90 AND 50 AND 60 AND NOT 50"
	actualKb = [[1],[2],[3],[-2]]
	test3 = KnowledgeBase.new("")
	assert_equal actualKb, test3.string_to_internal(stringKb)	
	assert_equal "60", test3.id_array[2].name
	assert_equal 3, test3.id_array[2].id
	assert_equal test3.name_hash["60"] , 3
	assert_equal test3.name_hash["NOT"] , nil
	
	stringKb = "p12 OR p13 or p14 or p15 or p12"
	actualKb = [[1,2,3,4,1]]
	test4 = KnowledgeBase.new("")
	assert_equal actualKb, test4.string_to_internal(stringKb)
	assert_equal test4.name_hash["p12"],1
	assert_equal test4.name_hash["p99"],nil
end
#
def test_eval
	stringKb = "p12 or p13 AND not p12 or p13"
	test1 = KnowledgeBase.new(stringKb)
	assignment =[-1,1]
	assert_equal 1 , test1.satisfiable_assignment?(assignment)
	assert_equal -1 ,test1.satisfiable_assignment?([1,-1]) 	
	
	stringKb = "p12 or not p13 and not p12 or p13"
	test2 = KnowledgeBase.new(stringKb)	
	assignment= [1,-1]
	assert_equal -1,test2.satisfiable_assignment?(assignment)
	assert_equal -1,test2.satisfiable_assignment?([-1,1])
	assert_equal 0,test2.satisfiable_assignment?([0,0])
	
	stringKb = "not p12 or p13 and p12 or p13 and not p13 or p12 and not p13 or not p12"
	test3 = KnowledgeBase.new(stringKb)
	assert_equal 0,test3.satisfiable_assignment?([-1,0])

	
end
def test_dpll
	stringKb = "not p13 or not p14 and p12 or not p13 and not p13 or p12 and p14 or not p13 and not p12 or not p14 and not p12 or not p13 and p12 or p13 and p12 or p14 and not p14 or not p13"
	test1 = KnowledgeBase.new(stringKb)
	assert_equal true, test1.dpll

	stringKb = "not p12 or p13 and p12 or p13 and not p13 or p12 and not p13 or not p12"
	test2 = KnowledgeBase.new(stringKb)
	assert_equal false, test2.dpll

	stringKb = "not 1 or not 2 and  2 or 1 and 2 or 3 and 1 or 3 and not 2 or not 3 and 2 or 3"
	test3 = KnowledgeBase.new(stringKb)
	assert_equal true, test3.dpll
	
	stringKb += " and 1 or 3 and not 1 or not 2 and 1 or 3 and 1 or 2"
	test4 = KnowledgeBase.new(stringKb)
	assert_equal true,test4.dpll
	
	stringKb = "not 2 or not 1 and  2 or 1 and 2 or 3 and 1 or 3 and not 2 or not 3 and 2 or 3"
	test5 = KnowledgeBase.new(stringKb)
	assert_equal true, test5.dpll
	
	stringKb += " and 1 or 3 and not 1 or not 2 and 1 or 3 and 1 or 2"
	test6 = KnowledgeBase.new(stringKb)
	assert_equal true,test6.dpll

	stringKb = "1 or 2 and not 2 or not 1 and not 2 or not 3 and 1 or 3 and not 2 or not 3"
	test7 = KnowledgeBase.new(stringKb)
	assert_equal true,test7.dpll
	
	stringKb += " and 1 or 3 and 1 or 3 and not 1 or not 3 and 1 or 2"
	test8 = KnowledgeBase.new(stringKb)
	assert_equal true, test8.dpll
	
	stringKb = "2 or 1 and not 2 or not 1 and not 2 or not 3 and 1 or 3 and not 2 or not 3"
	test9 = KnowledgeBase.new(stringKb)
	assert_equal true,test9.dpll
	
	stringKb10 =stringKb +  " and 1 or 3 and 1 or 3 and not 1 or not 3 and 1 or 2"
	test10 = KnowledgeBase.new(stringKb10)
	assert_equal true, test10.dpll
	
	stringKbys = "1 and 2"
	test15s = KnowledgeBase.new(stringKbys)
	assert_equal true,test15s.dpll
	
	stringKbys = "not 1 and 2 and not 3"
	test16s = KnowledgeBase.new(stringKbys)
	assert_equal true, test16s.dpll
	
	stringKbScon = "1 and not 1"
	test11 = KnowledgeBase.new(stringKbScon)
	assert_equal false, test11.dpll
	
	stringKbScon10 = stringKbScon +" and " + stringKb10
	testsl = KnowledgeBase.new(stringKbScon10)
	assert_equal false, testsl.dpll	

	stringKb = "1 and 2 and 3 and 4 and 5 and not 5 and 1 and 2 and 3 and 4 and 1 and 2 and 3 and 4"
	test12 = KnowledgeBase.new(stringKb)
	assert_equal false,test12.dpll

	stringKbLcon = " 1 or 2 and not 1 or not 2 and 2 or 3 and not 2 or not 3 and 1 or 3 and not 1 or not 3"
	test13 =  KnowledgeBase.new(stringKbLcon)
	assert_equal false, test13.dpll 
	
	stringKbLcon10 = stringKbLcon + " and " + stringKb10
	test14 =  KnowledgeBase.new(stringKbLcon10)
	assert_equal false, test14.dpll 

	##trying to test speed	

	long = "1 or 2 or 3 or not 4 and not 1 or not 2 or not 3 and 1 or 2 or 4 and 2 or 3 or not 1 and not 2 or not 4 or 1 and 1 or 2 or 4 and 3 or not 2 or not 1 and 1 or not 2 or not 3 and 2 or 3 or not 1 and not 3 or not 4 or not 1 and not 1 or 4 or 3 and  not 2 or not 4 or 3 and 1 or 4 or not 3 and 1 or 3 or 2 and not 1 or not 4 or 2 and 2 or not 3 or 4 and 2 or not 3 or not 4 and 1 or 3 or 4"
	testLong = KnowledgeBase.new(long)
	assert_equal false, testLong.dpll

end
end
