/*
 * Function: define_polygons
 * -------------------------
 * Defines polygon rings within a single level
 *
 * Arguments:
 * a: integer; array of start-nodes for each segment
 * b: integer; array of end-nodes for each segment
 * m: integer; number of segments
 *
 * Returns:
 * ans: integer; polygon rings defined by nodes and ring index
 */

#include <R.h>

int find_next_seg();
int start_new_seg();

void define_polygons(int *a, int *b, int *m, int *ans) {
  int i;
  int idx;
  int ply;
  int node;
  int nsegs = *m;

  idx = 0;
  ply = 1;

  for(i = 0; i < nsegs; i++) {
    node = b[idx];
    ans[i] = node;
    ans[nsegs + i] = ply;

    a[idx] = -1; /* exclude used points */
    b[idx] = -1;

    idx = find_next_seg(a, nsegs, node);

    if(idx < 0) {
      idx = start_new_seg(a, nsegs);
      ply += 1;
    }
  }
}

/* Find index for next segment by matching the end-node */
/* with start node of next segment */
int find_next_seg(int array[], int nelements, int value) {
  int i;
  for (i = 0; i < nelements; i++) {
    if (array[i] == value) { /* end-node equals start-node */
      return(i);
    }
  }
  return(-1);
}

/* Find index for start of new polygon by finding first */
/* unused segment */
int start_new_seg(int array[], int nelements) {
  int i;
  for (i = 0; i < nelements; i++) {
    if (array[i] > 0) { /* first unused point */
      return(i);
    }
  }
  return(-1);
}
