# --
# -- Tests de permisos (usar: mariadb --force < sql/Grados/test_grants.sql)
# --

mariadb --force -D GradesDB -uadmin_grados -pdruiz < test1.sql
mariadb --force -D GradesDB -uteacher_grados -pinmahernandez < test2.sql
mariadb --force -D GradesDB -ustudent_grados -pdavid.romero < test3.sql
