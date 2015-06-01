select *,111.045*degrees(acos(cos(radians(55.6712674))
                                                     * cos(radians(cast(lattitude as float	)))
                                                     * cos(radians(12.5608388) - radians(cast(longtitude as float)))
                                                     + sin(radians(55.6712674))
                                                     * sin(radians(cast(lattitude as float))))) as distance from "user" where 111.045*degrees(acos(cos(radians(55.6712674))
                                            * cos(radians(cast(lattitude as float	)))
                                            * cos(radians(12.5608388) - radians(cast(longtitude as float)))
                                            + sin(radians(55.6712674))
                                            * sin(radians(cast(lattitude as float))))) < 200;
