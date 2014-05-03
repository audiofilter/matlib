/*  CRC-32b version 1.03 by Craig Bruce, 27-Jan-94
**
**  Based on "File Verification Using CRC" by Mark R. Nelson in Dr. Dobb's
**  Journal, May 1992, pp. 64-67.  This program DOES generate the same CRC
**  values as ZMODEM and PKZIP
**
**  v1.00: original release.
**  v1.01: fixed printf formats.
**  v1.02: fixed something else.
**  v1.03: replaced CRC constant table by generator function.
*/

#include <stdio.h>

int main();
unsigned long getcrc();
void crcgen();

unsigned long crcTable[256];

/****************************************************************************/
int main( argc, argv )
	int argc;
	char *argv[];
{
	int	i;
	FILE   *fp;
	unsigned long crc;

	crcgen();
	if (argc < 2) {
		crc = getcrc( stdin );
		printf("crc32 = %08lx for <stdin>\n", crc);
	} else {
		for (i=1; i<argc; i++) {
			if ( (fp=fopen(argv[i],"rb")) == NULL ) {
				printf("error opening file \"%s\"!\n",argv[i]);
			} else {
				crc = getcrc( fp );
				printf("crc32 = %08lx for \"%s\"\n",
					crc, argv[i]);
				fclose( fp );
			}
		}
	}
	return( 0 );
}

/****************************************************************************/
unsigned long getcrc( fp )
	FILE *fp;
{
	register unsigned long crc;
	int c;

	crc = 0xFFFFFFFF;
	while( (c=getc(fp)) != EOF ) {
		crc = ((crc>>8) & 0x00FFFFFF) ^ crcTable[ (crc^c) & 0xFF ];
	}
	return( crc^0xFFFFFFFF );
}

/****************************************************************************/
void crcgen( )
{
	unsigned long	crc, poly;
	int	i, j;

	poly = 0xEDB88320L;
	for (i=0; i<256; i++) {
		crc = i;
		for (j=8; j>0; j--) {
			if (crc&1) {
				crc = (crc >> 1) ^ poly;
			} else {
				crc >>= 1;
			}
		}
		crcTable[i] = crc;
	}
}

