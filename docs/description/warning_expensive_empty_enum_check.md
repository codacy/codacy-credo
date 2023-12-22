Checking if the size of the enum is `0` can be very expensive, since you are
determining the exact count of elements.

Checking if an enum is empty should be done by using

    Enum.empty?(enum)

or

    list == []


For Enum.count/2: Checking if an enum doesn't contain specific elements should
be done by using

    not Enum.any?(enum, condition)

