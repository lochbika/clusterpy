subroutine clustering(indata, mask, nx, ny, outdata)

implicit none
integer, intent(in) :: nx, ny
integer, allocatable :: allIDs(:)
integer :: conx,cony,neighb(2)
real(kind=8), intent(in) :: indata(nx,ny),mask(nx,ny)
real(kind=8),intent(out) :: outdata(nx,ny)
logical :: lmask(nx,ny)
integer :: clID, i, x, y, tp, numIDs

! initialize variables and arrays
outdata=-999.D0
lmask=.false.
clID=0
numIDs=0

! mask values higher than threshold and if not missing value
do y=1,ny
do x=1,nx
    if(mask(x,y) == 1)lmask(x,y)=.true.
end do
end do

! check if there are any gridpoints to cluster
if(ANY(lmask))then

! assign IDs to continous cells
do y=1,ny
  do x=1,nx
    neighb=-999
    if(lmask(x,y))then
      ! gather neighbouring IDs; left,up
      if(x.ne.1)  neighb(1)=outdata((x-1),y)
      if(y.ne.1)  neighb(2)=outdata(x,(y-1))
      ! check if there is NO cluster around the current pixel; create new one
      if(ALL(neighb==-999))then
        outdata(x,y)=clID
        clID=clID+1
        numIDs=numIDs+1
      else
        ! both neighbours are in the same cluster
        if(neighb(1)==neighb(2).and.neighb(1).ne.-999)then
          outdata(x,y)=neighb(1)
        end if
        ! both neighbors are in different clusters but none of them is (-999)
        if(neighb(1).ne.neighb(2) .and. neighb(1).ne.-999 .and. neighb(2).ne.-999)then
          numIDs=numIDs-1
          outdata(x,y)=MINVAL(neighb)
          ! update the existing higher cluster with the lowest neighbour
          do cony=1,ny
            do conx=1,nx
              if(outdata(conx,cony)==MAXVAL(neighb))outdata(conx,cony)=MINVAL(neighb)
            end do
          end do
        end if
        ! both neighbors are in different clusters but ONE of them is empty(-999)
        if(neighb(1).ne.neighb(2) .and. (neighb(1)==-999 .or. neighb(2)==-999))then
          outdata(x,y)=MAXVAL(neighb)
        end if
      end if
    end if
  end do
end do

! gather IDs and rename to gapless ascending IDs
if(numIDs>0)then
  allocate(allIDs(numIDs))
  allIDs=-999
  clID=0
  tp=1
  do y=1,ny
    do x=1,nx
      if(.NOT.ANY(allIDs==outdata(x,y)) .AND. outdata(x,y).ne.-999)then
        allIDs(tp)=outdata(x,y)
        tp=tp+1
      end if
    end do
  end do

  do i=1,tp-1
    do y=1,ny
      do x=1,nx
        if(outdata(x,y)==allIDs(i))then
          outdata(x,y)=clID
        end if
      end do
    end do
    clID=clID+1
  end do
  deallocate(allIDs)
end if

end if
end subroutine clustering
