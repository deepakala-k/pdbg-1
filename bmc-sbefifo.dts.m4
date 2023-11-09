dnl
dnl SBEFIFO([index], [path-index])
dnl
define(`SBEFIFO',
`
	sbefifo@2400 { /* Bogus address */
		reg = <0x0 0x2400 0x7>;
		compatible = "ibm,kernel-sbefifo";
		index = <0x$1>;
		device-path = "/dev/sbefifo$2";

		sbefifo-pib {
			#address-cells = <0x2>;
			#size-cells = <0x1>;
			compatible = "ibm,sbefifo-pib";
			index = <0x$1>;
			system-path = "/proc$1/pib";
		};

		sbefifo-mem {
			compatible = "ibm,sbefifo-mem";
			index = <0x$1>;
			system-path = "/mem$1";
		};

		sbefifo-pba {
			compatible = "ibm,sbefifo-mem-pba";
			index = <0x$1>;
			system-path = "/mempba$1";
		};

		sbefifo-chipop {
			compatible = "ibm,sbefifo-chipop";
			index = <0x$1>;
		};
	};
')dnl


dnl
dnl FSI_PRE([addr], [index], [path-index])
dnl
define(`FSI_PRE',
`
	fsi@$1 {
		#address-cells = <0x2>;
		#size-cells = <0x1>;
		compatible = "ibm,kernel-fsi";
		device-path = "/fsi0/slave@00:00/raw";
		reg = <0x0 0x$1 0x8000>;
		index = <0x$2>;
		status = "mustexist";
		system-path = "/proc$2/fsi";

		SBEFIFO($2, $3)
')dnl

dnl
dnl FSI_POST()
dnl
define(`FSI_POST',
`
	};
')dnl

dnl
dnl HMFSI([addr], [port], [index], [path-index])
dnl
define(`HMFSI',
`
	hmfsi@$1 {
		#address-cells = <0x2>;
		#size-cells = <0x1>;
		compatible = "ibm,kernel-fsi";
		device-path = "/fsi1/slave@0$2:00/raw";
		reg = <0x0 0x$1 0x8000>;
		port = <0x$2>;
		index = <0x$3>;
		system-path = "/proc$3/fsi";

		SBEFIFO($3, $4)
	};
')dnl

dnl
dnl SBEFIFO_OCMB([index], [proc], [proc], [proc+1], [port] [])
dnl
define(`SBEFIFO_OCMB',
`
	sbefifo-ocmb@$3$4{ /* Bogus address */
		#address-cells = <0x1>;
		#size-cells = <0x1>;
		compatible = "ibm,kernel-sbefifo";
		reg = <0x0 0x1>; /*dummy to fix dts warning*/
		index = <0x$1>;
		proc = <0x$2>;
		port = <0x$3>;
		device-path = "/dev/sbefifo$3$4";
	};
')dnl

dnl
dnl HMFSI_OCMB([index], [proc], [proc+1], [port])
dnl
define(`HMFSI_OCMB',
`
	hmfsi-ocmb@$3$4 {
		#address-cells = <0x1>;
		#size-cells = <0x1>;
		compatible = "ibm,kernel-fsi";
		device-path = "/i2cr$3$4/slave@00:00/raw";
		reg = <0x0 0x1>; /*dummy to fix dts warning*/
		index = <0x$1>;
		proc = <0x$2>;
		port = <0x$3>;

		SBEFIFO_OCMB($1, $2, $3, $4)
	};
')dnl

dnl
dnl BMC_I2CBUS([index])
dnl
define(`BMC_I2CBUS',
`
	bmc-i2c-bus$1 {
		#address-cells = <0x1>;
		#size-cells = <0x0>;
		index = <$1>;
		compatible = "ibm,kernel-i2c-bus";
		device-path = "/dev/i2c-$1";
		system-path = "/bmc0/i2c-$1";
	};
')dnl


/dts-v1/;

/ {
	#address-cells = <0x1>;
	#size-cells = <0x0>;

	BMC_I2CBUS(0)
	BMC_I2CBUS(1)
	BMC_I2CBUS(2)
	BMC_I2CBUS(3)
	BMC_I2CBUS(4)
	BMC_I2CBUS(5)
	BMC_I2CBUS(6)
	BMC_I2CBUS(7)
	BMC_I2CBUS(8)
	BMC_I2CBUS(9)
	BMC_I2CBUS(10)
	BMC_I2CBUS(11)
	BMC_I2CBUS(12)
	BMC_I2CBUS(13)
	BMC_I2CBUS(14)
	BMC_I2CBUS(15)

	FSI_PRE(0, 0, 1)

	HMFSI(100000, 1, 1, 2)
	HMFSI(180000, 2, 2, 3)
	HMFSI(200000, 3, 3, 4)
	HMFSI(280000, 4, 4, 5)
	HMFSI(300000, 5, 5, 6)
	HMFSI(380000, 6, 6, 7)
	HMFSI(400000, 7, 7, 8)

	FSI_POST()

	HMFSI_OCMB(0, 0, 1, 00)
	HMFSI_OCMB(1, 0, 1, 01)
	HMFSI_OCMB(2, 0, 1, 10)
	HMFSI_OCMB(3, 0, 1, 11)
	HMFSI_OCMB(4, 0, 1, 12)
	HMFSI_OCMB(5, 0, 1, 13)
	HMFSI_OCMB(6, 0, 1, 14)
	HMFSI_OCMB(7, 0, 1, 15)

	HMFSI_OCMB(0, 1, 2, 02)
	HMFSI_OCMB(1, 1, 2, 03)
	HMFSI_OCMB(2, 1, 2, 10)
	HMFSI_OCMB(3, 1, 2, 11)
	HMFSI_OCMB(4, 1, 2, 14)
	HMFSI_OCMB(5, 1, 2, 15)
	HMFSI_OCMB(6, 1, 2, 16)
	HMFSI_OCMB(7, 1, 2, 17)


	HMFSI_OCMB(0, 2, 3, 00)
	HMFSI_OCMB(1, 2, 3, 01)
	HMFSI_OCMB(2, 2, 3, 10)
	HMFSI_OCMB(3, 2, 3, 11)
	HMFSI_OCMB(4, 2, 3, 12)
	HMFSI_OCMB(5, 2, 3, 13)
	HMFSI_OCMB(6, 2, 3, 14)
	HMFSI_OCMB(7, 2, 3, 15)

	HMFSI_OCMB(0, 3, 4, 02)
	HMFSI_OCMB(1, 3, 4, 03)
	HMFSI_OCMB(2, 3, 4, 10)
	HMFSI_OCMB(3, 3, 4, 11)
	HMFSI_OCMB(4, 3, 4, 14)
	HMFSI_OCMB(5, 3, 4, 15)
	HMFSI_OCMB(6, 3, 4, 16)
	HMFSI_OCMB(7, 3, 4, 17)

	HMFSI_OCMB(0, 4, 5, 00)
	HMFSI_OCMB(1, 4, 5, 01)
	HMFSI_OCMB(2, 4, 5, 10)
	HMFSI_OCMB(3, 4, 5, 11)
	HMFSI_OCMB(4, 4, 5, 12)
	HMFSI_OCMB(5, 4, 5, 13)
	HMFSI_OCMB(6, 4, 5, 14)
	HMFSI_OCMB(7, 4, 5, 15)

	HMFSI_OCMB(0, 5, 6, 02)
	HMFSI_OCMB(1, 5, 6, 03)
	HMFSI_OCMB(2, 5, 6, 10)
	HMFSI_OCMB(3, 5, 6, 11)
	HMFSI_OCMB(4, 5, 6, 14)
	HMFSI_OCMB(5, 5, 6, 15)
	HMFSI_OCMB(6, 5, 6, 16)
	HMFSI_OCMB(7, 5, 6, 17)

	HMFSI_OCMB(0, 6, 7, 00)
	HMFSI_OCMB(1, 6, 7, 01)
	HMFSI_OCMB(2, 6, 7, 10)
	HMFSI_OCMB(3, 6, 7, 11)
	HMFSI_OCMB(4, 6, 7, 12)
	HMFSI_OCMB(5, 6, 7, 13)
	HMFSI_OCMB(6, 6, 7, 14)
	HMFSI_OCMB(7, 6, 7, 15)

	HMFSI_OCMB(0, 7, 8, 02)
	HMFSI_OCMB(1, 7, 8, 03)
	HMFSI_OCMB(2, 7, 8, 10)
	HMFSI_OCMB(3, 7, 8, 11)
	HMFSI_OCMB(4, 7, 8, 14)
	HMFSI_OCMB(5, 7, 8, 15)
	HMFSI_OCMB(6, 7, 8, 16)
	HMFSI_OCMB(7, 7, 8, 17)
};
