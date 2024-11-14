import React, { useState, useEffect, useRef } from 'react';

export interface Option {
  Key: string;
  Value: string;
}

interface SelectionDialogProps {
  options: Option[];
  defaultSelectedKey?: string;
  onConfirm: (selectedKey: string | null) => void;
  onCancel: () => void;
}

const SelectionDialog: React.FC<SelectionDialogProps> = ({ options, defaultSelectedKey, onConfirm, onCancel }) => {
  const [selectedIndex, setSelectedIndex] = useState<number>(0);
  const dialogRef = useRef<HTMLDivElement>(null);
  const itemRefs = useRef<(HTMLLIElement | null)[]>([]);

  useEffect(() => {
    const defaultIndex = options.findIndex(option => option.Key === defaultSelectedKey);
    if (defaultIndex !== -1) {
      setSelectedIndex(defaultIndex);
    }
    dialogRef.current?.focus();
  }, [defaultSelectedKey, options]);

  useEffect(() => {
    const currentItem = itemRefs.current[selectedIndex];
    if (currentItem) {
      currentItem.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    }
  }, [selectedIndex]);

  const handleKeyDown = (event: React.KeyboardEvent<HTMLDivElement>) => {
    if (event.key === 'ArrowDown') {
      setSelectedIndex((prevIndex) => Math.min(prevIndex + 1, options.length - 1));
    } else if (event.key === 'ArrowUp') {
      setSelectedIndex((prevIndex) => Math.max(prevIndex - 1, 0));
    } else if (event.key === 'Enter') {
      onConfirm(options[selectedIndex].Key);
    } else if (event.key === 'Escape') {
      onCancel();
    }
  };

  const handleClick = (index: number) => {
    setSelectedIndex(index);
  };

  return (
    <div
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        width: '100vw',
        height: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        zIndex: 1000,
      }}
    >
      <div
        ref={dialogRef}
        tabIndex={0}
        onKeyDown={handleKeyDown}
        style={{
          width: '50%',
          maxHeight: '80%',
          backgroundColor: 'white',
          border: '1px solid #ccc',
          borderRadius: '8px',
          padding: '16px',
          boxShadow: '0 4px 8px rgba(0, 0, 0, 0.2)',
          display: 'flex',
          flexDirection: 'column',
        }}
      >
        <ul
          style={{
            listStyleType: 'none',
            padding: 0,
            margin: 0,
            overflowY: 'auto',
            maxHeight: 'calc(80vh - 100px)', // Ограничиваем высоту списка
            flexGrow: 1,
          }}
        >
          {options.map((option, index) => (
            <li
              key={option.Key}
              ref={(el) => (itemRefs.current[index] = el)}
              onClick={() => handleClick(index)}
              style={{
                padding: '8px',
                backgroundColor: index === selectedIndex ? '#e0e0e0' : 'white',
                cursor: 'pointer',
              }}
            >
              {option.Value}
            </li>
          ))}
        </ul>
        <div style={{ marginTop: '16px', textAlign: 'right' }}>
          <button onClick={() => onConfirm(options[selectedIndex].Key)}>OK</button>
          <button onClick={onCancel} style={{ marginLeft: '8px' }}>
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};

export default SelectionDialog;
