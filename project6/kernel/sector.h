#ifndef SECTOR_H
#define SECTOR_H

extern void _load(int,int,int,int,int);

class Sector
{
public:
    Sector() = default;
    Sector(int start_addr, int end_addr)
    {
        int sec = start_addr / 0x200;           //物理扇区号
        int y = sec / 18;
        this->_cylinder = (y >> 1);
        this->_track = (y & 1);
        int z = sec % 18;
        this->_index = z + 1;
        this->_bytes = end_addr - start_addr + 1;
    }
    
    int bytes() const
    {
        return _bytes;
    }

    int cylinder() const
    {
        return _cylinder;
    }

    int track() const
    {
        return _track;
    }

    int indexOfFloppy() const
    {
        return _index;
    }

    int numSectors() const
    {
        int length = _bytes / 0x200;
        if (_bytes % 0x200)
        {
            length++;
        }
        return length;
    }

    void loadToMemory(int load_addr) const
    {
        int length = numSectors();
        _load(_cylinder, _track, _index, length, load_addr);
    }
private:
    int _cylinder;
    int _track;
    int _index;
    int _bytes;
};

#endif // SECTOR_H
